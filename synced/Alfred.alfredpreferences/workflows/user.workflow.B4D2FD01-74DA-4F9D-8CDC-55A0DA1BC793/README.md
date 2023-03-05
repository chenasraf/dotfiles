# GitLab Projects Search Alfred Workflow

## How to use

Use these commands with your search query as the arguments (min 3 chars for search):

- `gl <search>` - open a project's overview
- `glp <search>` - open project's Pipelines page
- `glm <search>` - open project's MRs page

Confirm a result to open it on your default browser.

## Troubleshooting

Use `.glc` command (no arguments) to clear all the result caches.

Use this if there are new projects that do not appear in results, or user/group scoping has changed.

## Requirements

- Needs a
  [GitLab personal access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
  to work
- Needs [jq](https://stedolan.github.io/jq/download/) to be installed
