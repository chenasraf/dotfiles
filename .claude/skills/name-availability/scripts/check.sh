#!/usr/bin/env bash
# Name availability checker
# Outputs one line per axis: axis|status|detail
# Usage: check.sh <name> [--tlds "com dev app"] [--registries "npm pub.dev crates.io pypi"]

set -u

NAME=""
# Default TLDs: broadly useful baseline. ALWAYS extend per project space:
# media/streaming → +tv; AI/ML → +ai; gaming → +gg/games; finance → +finance; etc.
TLDS="com dev app io org co tv"
# Default registries: broadly useful baseline. ALWAYS extend per stack:
# Go/CLI → +homebrew; PHP → +packagist; Ruby → +rubygems; etc.
REGISTRIES="npm pub.dev crates.io pypi"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tlds)       TLDS="$2"; shift 2 ;;
    --registries) REGISTRIES="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: $0 <name> [--tlds 'com dev app'] [--registries 'npm pub.dev crates.io pypi rubygems packagist homebrew']" >&2
      exit 0 ;;
    *)            NAME="$1"; shift ;;
  esac
done

if [[ -z "$NAME" ]]; then
  echo "ERROR: name required" >&2
  echo "Usage: $0 <name> [--tlds '...'] [--registries '...']" >&2
  exit 1
fi

# Lowercase the name for registries / GitHub / domains
NAME_LC=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

http_status() {
  curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$1" 2>/dev/null
}

# Map TLD → registry WHOIS server for definitive "No match" answers.
# Empty = no known direct WHOIS server, fall back to NS-only check.
whois_server_for_tld() {
  case "$1" in
    com|net) echo "whois.verisign-grs.com" ;;
    org)     echo "whois.publicinterestregistry.org" ;;
    dev|app|page|new) echo "whois.nic.google" ;;
    io)      echo "whois.nic.io" ;;
    co)      echo "whois.nic.co" ;;
    me)      echo "whois.nic.me" ;;
    tv)      echo "whois.nic.tv" ;;
    ai)      echo "whois.nic.ai" ;;
    *)       echo "" ;;
  esac
}

# Patterns that indicate "domain unregistered" in WHOIS output across registries.
WHOIS_NEG_PATTERNS='no match for|domain not found|no entries found|no data found|status:[ \t]*available|not found:|^no found|^no_object_found'

# ---------- Domains ----------
for tld in $TLDS; do
  domain="${NAME_LC}.${tld}"

  # Try registry-direct WHOIS first if we know the server
  whois_srv=$(whois_server_for_tld "$tld")
  if [[ -n "$whois_srv" ]]; then
    whois_out=$(whois -h "$whois_srv" "$domain" 2>/dev/null)
    if echo "$whois_out" | grep -qiE "$WHOIS_NEG_PATTERNS"; then
      echo "domain:$tld|unregistered|$whois_srv: no match (definitive)"
      continue
    fi
    # If we got recognizable registration data, mark as registered
    if echo "$whois_out" | grep -qiE "^(domain name|registry expiry|creation date|name server|registrar:):"; then
      registrar=$(echo "$whois_out" | grep -iE "^registrar:" | head -1 | sed 's/.*: *//' | tr -d '\r')
      [[ -z "$registrar" ]] && registrar="unknown registrar"
      echo "domain:$tld|registered|via $whois_srv ($registrar)"
      continue
    fi
    # WHOIS responded but format unrecognized — fall through to NS check
  fi

  # NS check via public resolver, with short timeout, system resolver fallback
  ns_out=$(dig +short +time=3 +tries=1 NS "$domain" @8.8.8.8 2>&1)
  ns=$(echo "$ns_out" | grep -v '^;' | head -1)

  if echo "$ns_out" | grep -qiE "timed out|no servers|servfail|connection refused"; then
    # Fallback: system resolver
    ns_out=$(dig +short +time=3 +tries=1 NS "$domain" 2>&1)
    ns=$(echo "$ns_out" | grep -v '^;' | head -1)
  fi

  if echo "$ns_out" | grep -qiE "timed out|no servers|servfail|connection refused"; then
    echo "domain:$tld|unknown|DNS lookup failed (verify manually)"
  elif [[ -z "$ns" ]]; then
    echo "domain:$tld|unregistered|No NS records"
  else
    echo "domain:$tld|registered|NS: $ns"
  fi
done

# ---------- GitHub org ----------
gh_org_code=$(http_status "https://api.github.com/orgs/${NAME_LC}")
gh_org_exists=0
case "$gh_org_code" in
  404)
    echo "github:org|available|API 404"
    ;;
  200)
    gh_org_exists=1
    info=$(curl -s --max-time 10 "https://api.github.com/orgs/${NAME_LC}" 2>/dev/null \
      | python3 -c "import sys,json
try:
  d = json.load(sys.stdin)
  print(f\"{d.get('public_repos',0)} repos, created {d.get('created_at','?')[:10]}, login={d.get('login','?')}\")
except Exception:
  print('exists')" 2>/dev/null)
    [[ -z "$info" ]] && info="exists"
    echo "github:org|exists|$info"
    ;;
  *)
    echo "github:org|unknown|HTTP $gh_org_code"
    ;;
esac

# ---------- GitHub user ----------
# Skip if org exists (GitHub shares the namespace; user route returns 200 for orgs too)
if [[ "$gh_org_exists" -eq 0 ]]; then
  gh_user_code=$(http_status "https://api.github.com/users/${NAME_LC}")
  case "$gh_user_code" in
    404) echo "github:user|available|API 404" ;;
    200) echo "github:user|exists|user account exists" ;;
    *)   echo "github:user|unknown|HTTP $gh_user_code" ;;
  esac
else
  echo "github:user|n/a|namespace shared with org (skipped)"
fi

# ---------- Package registries ----------
for reg in $REGISTRIES; do
  case "$reg" in
    npm)
      code=$(http_status "https://registry.npmjs.org/${NAME_LC}")
      [[ "$code" == "404" ]] && echo "pkg:npm|available|404" || echo "pkg:npm|exists|HTTP $code"
      ;;
    pub.dev)
      code=$(http_status "https://pub.dev/api/packages/${NAME_LC}")
      [[ "$code" == "404" ]] && echo "pkg:pub.dev|available|404" || echo "pkg:pub.dev|exists|HTTP $code"
      ;;
    crates.io)
      code=$(http_status "https://crates.io/api/v1/crates/${NAME_LC}")
      [[ "$code" == "404" ]] && echo "pkg:crates.io|available|404" || echo "pkg:crates.io|exists|HTTP $code"
      ;;
    pypi)
      code=$(http_status "https://pypi.org/pypi/${NAME_LC}/json")
      [[ "$code" == "404" ]] && echo "pkg:pypi|available|404" || echo "pkg:pypi|exists|HTTP $code"
      ;;
    rubygems)
      code=$(http_status "https://rubygems.org/api/v1/gems/${NAME_LC}.json")
      [[ "$code" == "404" ]] && echo "pkg:rubygems|available|404" || echo "pkg:rubygems|exists|HTTP $code"
      ;;
    packagist)
      code=$(http_status "https://packagist.org/packages/${NAME_LC}.json")
      [[ "$code" == "404" ]] && echo "pkg:packagist|available|404" || echo "pkg:packagist|exists|HTTP $code"
      ;;
    homebrew)
      code=$(http_status "https://formulae.brew.sh/api/formula/${NAME_LC}.json")
      [[ "$code" == "404" ]] && echo "pkg:homebrew|available|404" || echo "pkg:homebrew|exists|HTTP $code"
      ;;
    *)
      echo "pkg:$reg|unknown|registry not implemented in script"
      ;;
  esac
done

# ---------- Mastodon (mastodon.social as default instance probe) ----------
masto_code=$(http_status "https://mastodon.social/@${NAME_LC}")
case "$masto_code" in
  404) echo "social:mastodon.social|available|404 on default instance" ;;
  *)   echo "social:mastodon.social|unknown|HTTP $masto_code (verify on specific instance if needed)" ;;
esac

# ---------- Bluesky ----------
bsky_resp=$(curl -s --max-time 10 "https://bsky.social/xrpc/com.atproto.identity.resolveHandle?handle=${NAME_LC}.bsky.social" 2>/dev/null)
if echo "$bsky_resp" | grep -qiE "unable to resolve|invalidrequest"; then
  echo "social:bluesky|available|handle ${NAME_LC}.bsky.social not registered"
elif echo "$bsky_resp" | grep -q "did:"; then
  echo "social:bluesky|exists|handle resolved to a DID"
else
  echo "social:bluesky|unknown|unexpected response"
fi

# ---------- Manual-check axes ----------
echo "social:x-reddit-instagram|manual-check|anti-bot blocks programmatic check; verify manually"
echo "trademark|manual-check|verify at https://tmsearch.uspto.gov (cl. 9/41/42) and https://www.tmdn.org/tmview"
echo "existing-products|manual-check|run web search for the bare name + '<name> <space>' + '<name> trademark'"
