const apiUrl = process.env.WORDPRESS_API_URL || 'http://localhost/wp-json/wp/v2'

export interface WordPressPost {
  id: number
  date: string
  slug: string
  title: {
    rendered: string
  }
  content: {
    rendered: string
  }
  excerpt: {
    rendered: string
  }
  featured_media: number
  _embedded?: {
    'wp:featuredmedia'?: Array<{
      source_url: string
      alt_text: string
    }>
  }
}

export interface WordPressPage {
  id: number
  date: string
  slug: string
  title: {
    rendered: string
  }
  content: {
    rendered: string
  }
}

export async function getPosts(): Promise<WordPressPost[]> {
  try {
    const response = await fetch(`${apiUrl}/posts?_embed=wp:featuredmedia`)
    if (!response.ok) {
      throw new Error('Failed to fetch posts')
    }
    return await response.json()
  } catch (error) {
    console.error('Error fetching posts:', error)
    return []
  }
}

export async function getPost(slug: string): Promise<WordPressPost | null> {
  try {
    const response = await fetch(`${apiUrl}/posts?slug=${slug}&_embed=wp:featuredmedia`)
    if (!response.ok) {
      throw new Error('Failed to fetch post')
    }
    const posts = await response.json()
    return posts.length > 0 ? posts[0] : null
  } catch (error) {
    console.error('Error fetching post:', error)
    return null
  }
}

export async function getPages(): Promise<WordPressPage[]> {
  try {
    const response = await fetch(`${apiUrl}/pages`)
    if (!response.ok) {
      throw new Error('Failed to fetch pages')
    }
    return await response.json()
  } catch (error) {
    console.error('Error fetching pages:', error)
    return []
  }
}

export async function getPage(slug: string): Promise<WordPressPage | null> {
  try {
    const response = await fetch(`${apiUrl}/pages?slug=${slug}`)
    if (!response.ok) {
      throw new Error('Failed to fetch page')
    }
    const pages = await response.json()
    return pages.length > 0 ? pages[0] : null
  } catch (error) {
    console.error('Error fetching page:', error)
    return null
  }
}