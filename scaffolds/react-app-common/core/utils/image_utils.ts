export function fallbackImageUrl(
  text: string,
  { width, height }: Record<'width' | 'height', number>,
): string {
  const qs = new URLSearchParams({
    bg_color: '008000',
    fg_color: 'FFFFFF',
    text,
  })

  return `https://placeholder.photo/img/${width}x${height}?` + qs.toString()
}

export function apiFallbackImageUrl(url: string): string {
  return `/api/image?url=${decodeURIComponent(url)}`
}
