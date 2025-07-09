import { Page as TPage } from "../../lib/types";
import { headers } from "next/headers"

export async function generateStaticParams() {

  const headersData = headers();
  const protocol = headersData.get('x-forwarded-proto') || 'http';
  const host = headersData.get('host')

  const baseUrl = `${protocol}://${host}`;
  const response = await fetch(`${baseUrl}/api/wp-json/wp/v2/pages?_fields[]=slug`);
  const pages : TPage[] = await response.json();
  const paths = pages.map(page => ({
    slug: page.slug 
  }));
  return paths;
}

export default async function Page({ params }: { params: { slug: string } }) {  
  const headersData = headers();
  const protocol = headersData.get('x-forwarded-proto') || 'http';
  const host = headersData.get('host')

  const baseUrl = `${protocol}://${host}`;
    // Fetch the blog post data based on the slug (you may use an API or other method)
    const response = await fetch(`${baseUrl}/api/wp-json/wp/v2/pages/?slug=${params.slug}`);
    const page : TPage = (await response.json())[0];

    return (
      <div className="my-8 max-w-3xl m-auto">
        <h1 className="text-3xl font-semibold my-4">{page.title.rendered}</h1>
        <div className="prose" dangerouslySetInnerHTML={{ __html: page.content.rendered }} />

      </div>
    );
}



