import Link from 'next/link'
import { notFound } from 'next/navigation'
import { getPost, getPosts } from '../../../lib/wordpress'

interface Props {
  params: {
    slug: string
  }
}

export async function generateStaticParams() {
  const posts = await getPosts()
  return posts.map((post) => ({
    slug: post.slug,
  }))
}

export default async function PostPage({ params }: Props) {
  const post = await getPost(params.slug)

  if (!post) {
    notFound()
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <nav className="mb-8">
        <Link 
          href="/"
          className="text-blue-600 hover:text-blue-800 font-medium"
        >
          ← Back to all posts
        </Link>
      </nav>

      <article className="max-w-4xl mx-auto">
        <header className="mb-8">
          {post._embedded?.['wp:featuredmedia']?.[0] && (
            <img
              src={post._embedded['wp:featuredmedia'][0].source_url}
              alt={post._embedded['wp:featuredmedia'][0].alt_text || post.title.rendered}
              className="w-full h-64 md:h-96 object-cover rounded-lg mb-6"
            />
          )}
          
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
            {post.title.rendered}
          </h1>
          
          <div className="flex items-center text-gray-600 mb-6">
            <time dateTime={post.date} className="text-sm">
              Published on {new Date(post.date).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
              })}
            </time>
          </div>
        </header>

        <div 
          className="prose prose-lg prose-gray max-w-none"
          dangerouslySetInnerHTML={{ __html: post.content.rendered }}
        />
      </article>
    </div>
  )
}