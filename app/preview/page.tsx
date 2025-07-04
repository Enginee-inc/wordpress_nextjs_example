'use client';

import { useSearchParams } from 'next/navigation';
import { useEffect, useState } from 'react';
import { Page as TPage } from "../lib/types";

export default function Preview() {
  const searchParams = useSearchParams();
  const id = searchParams.get('id');
  const [page, setPage] = useState<TPage | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) {
      setError('No page ID provided');
      setLoading(false);
      return;
    }

    const fetchPreview = async () => {
      try {
        const response = await fetch(`/api/preview?id=${id}`);
        
        if (!response.ok) {
          const data = await response.json();
          throw new Error(data.error || 'Failed to load preview');
        }

        const pageData = await response.json();
        setPage(pageData);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Error loading preview');
      } finally {
        setLoading(false);
      }
    };

    fetchPreview();
  }, [id]);

  if (loading) {
    return <div className="my-8 max-w-3xl m-auto">Loading preview...</div>;
  }

  if (error) {
    return <div className="my-8 max-w-3xl m-auto">Error: {error}</div>;
  }

  if (!page) {
    return <div className="my-8 max-w-3xl m-auto">No page data available</div>;
  }

  return (
    <div className="my-8 max-w-3xl m-auto">
      <h1 className="text-3xl font-semibold my-4">{page.title.rendered}</h1>
      <div className="prose" dangerouslySetInnerHTML={{ __html: page.content.rendered }} />
    </div>
  );
}