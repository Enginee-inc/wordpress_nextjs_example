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
export const getPosts = async () => ([{
  id: 1,
  title: { rendered: 'Example Post' },
  date: new Date().toISOString(),
  content: { rendered: '<p>This is  an example post content.</p>' },  
  excerpt: { rendered: '<p>This is an example post excerpt.</p>' },
  _embedded: {
    'wp:featuredmedia': [
      {
        source_url: 'https://example.com/image.jpg',
        alt_text: 'Example Post Image',
      },
    ],
  },
  slug: 'example-post',
}])

export const getPost = async (slug:string) => ({
  id: 1,
  title: { rendered: 'Example Post' },
  date: new Date().toISOString(),
  content: { rendered: '<p>This is an example post content.</p>' },
  excerpt: { rendered: '<p>This is an example post excerpt.</p>' },
  _embedded: {
    'wp:featuredmedia': [
      {
        source_url: 'https://example.com/image.jpg',
        alt_text: 'Example Post Image',
      },
    ],
  },
  slug: 'example-post',
})

export const getPages = async () => ([{
  id: 1,
  date: new Date().toISOString(),
  slug: 'example-page',
  title: { rendered: 'Example Page' },
  content: { rendered: '<p>This is an example page content.</p>' },
}])

export const getPage = async (slug: string) => ({
  id: 1,
  date: new Date().toISOString(),
  slug: 'example-page',
  title: { rendered: 'Example Page' },
  content: { rendered: '<p>This is an example page content.</p>' },
})
// export async function getPosts(): Promise<WordPressPost[]> {
//   try {
//     const response = await fetch(`${apiUrl}/posts?_embed=wp:featuredmedia`)
//     if (!response.ok) {
//       throw new Error('Failed to fetch posts')
//     }
//     return await response.json()
//   } catch (error) {
//     console.error('Error fetching posts:', error)
//     return []
//   }
// }

// export async function getPost(slug: string): Promise<WordPressPost | null> {
//   try {
//     const response = await fetch(`${apiUrl}/posts?slug=${slug}&_embed=wp:featuredmedia`)
//     if (!response.ok) {
//       throw new Error('Failed to fetch post')
//     }
//     const posts = await response.json()
//     return posts.length > 0 ? posts[0] : null
//   } catch (error) {
//     console.error('Error fetching post:', error)
//     return null
//   }
// }

// export async function getPages(): Promise<WordPressPage[]> {
//   try {
//     const response = await fetch(`${apiUrl}/pages`)
//     if (!response.ok) {
//       throw new Error('Failed to fetch pages')
//     }
//     return await response.json()
//   } catch (error) {
//     console.error('Error fetching pages:', error)
//     return []
//   }
// }

// export async function getPage(slug: string): Promise<WordPressPage | null> {
//   try {
//     const response = await fetch(`${apiUrl}/pages?slug=${slug}`)
//     if (!response.ok) {
//       throw new Error('Failed to fetch page')
//     }
//     const pages = await response.json()
//     return pages.length > 0 ? pages[0] : null
//   } catch (error) {
//     console.error('Error fetching page:', error)
//     return null
//   }
// }