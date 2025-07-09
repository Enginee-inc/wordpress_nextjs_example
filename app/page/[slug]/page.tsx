import { Page as TPage } from "../../lib/types";

export async function generateStaticParams() {


  const baseUrl = "https://wp-app-web-62319.azurewebsites.net"
  const response = await fetch(`${baseUrl}/wp-json/wp/v2/pages?_fields[]=slug`);
  const pages : TPage[] = await response.json();
  const paths = pages.map(page => ({
    slug: page.slug 
  }));
  return paths;
}

export default async function Page({ params }: { params: { slug: string } }) {  
    const baseUrl = "https://thankful-water-09578c61e.1.azurestaticapps.net"
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



