import { Page as TPage } from "../lib/types";

const wordpressUrl = process.env.WORDPRESS_URL;
const wpUser = process.env.WORDPRESS_USER;
const wpAppPassword = process.env.WORDPRESS_APP_PASSWORD;

export default async function Preview({
  searchParams,
}: {
  searchParams: { id?: string };
}) {
  if (!searchParams.id) {
    return <div>No page ID provided</div>;
  }
  try {
    const response = await fetch(
      `${wordpressUrl}/wp-json/wp/v2/pages/${searchParams.id}?_embed&status=draft`,
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${Buffer.from(`${wpUser}:${wpAppPassword}`).toString('base64')}`
        },
        cache: 'no-store' // Always fetch fresh data for previews
      }
    );

    if (!response.ok) {
      return <div>Failed to load preview</div>;
    }

    const page: TPage = await response.json();

  return (
    <div className="my-8 max-w-3xl m-auto">
      <h1 className="text-3xl font-semibold my-4">{page.title.rendered}</h1>
      <div className="prose" dangerouslySetInnerHTML={{ __html: page.content.rendered }} />
    </div>
  );

 } catch (error) {
    console.error("Error fetching page preview:", error);
    return <div>Error loading preview {error}</div>;
  }
}