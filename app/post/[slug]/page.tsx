import { BlogPost } from '@/app/components/blogpost';
import { Post } from '@/app/lib/types';
import { headers } from 'next/headers';


export async function generateStaticParams(){
  const headersData = headers();
    const protocol = headersData.get('x-forwarded-proto') || 'http';
    const host = headersData.get('host')
  
    const baseUrl = `${protocol}://${host}`;
  const response = await fetch(`${baseUrl}/api/wp-json/wp/v2/posts?_fields[]=slug`);
  const posts : Post[] = await response.json();
  const paths = posts.map(post => ({
    slug: post.slug 
  }));
  return paths;
}

export default async function BlogPage({ params }: { params: { slug: string } }) {  
    // Fetch the blog post data based on the slug (you may use an API or other method)
    const headersData = headers();
    const protocol = headersData.get('x-forwarded-proto') || 'http';
    const host = headersData.get('host')
  
    const baseUrl = `${protocol}://${host}`;
    const response = await fetch(`${baseUrl}/api/wp-json/wp/v2/posts/?slug=${params.slug}&_embed`);
    const post: Post = (await response.json())[0];

    return (
      <div>
        <BlogPost post={post} /> 
      </div>
      
    );
}
