import { GetServerSideProps } from 'next';
import Page  from "../../page/[slug]/page";
import { Page as TPage } from "../../lib/types";

const wordpressUrl = process.env.WORDPRESS_URL;

export const getServerSideProps: GetServerSideProps = async (context) => {
  const response = await fetch(`${wordpressUrl}/wp-json/wp/v2/pages/${context.query.id}?_embed&status=draft`,
    {
      headers: {
        'Content-Type': 'application/json',
      }
    }
  );

  const pages : TPage = await response.json();
  return { props: pages };
};

const Preview = (props: { page: TPage }) => {
  return (
    <div className="my-8 max-w-3xl m-auto">
      <h1 className="text-3xl font-semibold my-4">{props.page.title.rendered}</h1>
      <div className="prose" dangerouslySetInnerHTML={{ __html: props.page.content.rendered }} />
    </div>
  );
};

export default Preview;