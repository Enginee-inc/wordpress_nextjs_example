import { NextRequest, NextResponse } from 'next/server';
import { Page as TPage } from '../../lib/types';

const wordpressUrl = process.env.WORDPRESS_URL;
const wpUser = process.env.WORDPRESS_USER;
const wpAppPassword = process.env.WORDPRESS_APP_PASSWORD;

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const id = searchParams.get('id');

  if (!id) {
    return NextResponse.json({ error: 'No page ID provided' }, { status: 400 });
  }

  if (!wordpressUrl || !wpUser || !wpAppPassword) {
    
    if (!wordpressUrl) {
      console.error("WORDPRESS_URL is not set");
    }
    return NextResponse.json({ error: `WordPress configuration missing, ${!!wordpressUrl}, ${!!wpUser}, ${!!wpAppPassword}` }, { status: 500 });
  }

  try {
    const response = await fetch(
      `${wordpressUrl}/wp-json/wp/v2/pages/${id}?_embed&status=draft`,
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${Buffer.from(`${wpUser}:${wpAppPassword}`).toString('base64')}`
        },
        cache: 'no-store'
      }
    );

    if (!response.ok) {
      return NextResponse.json({ error: 'Failed to load preview' }, { status: response.status });
    }

    const page: TPage = await response.json();
    return NextResponse.json(page);

  } catch (error) {
    console.error("Error fetching page preview:", error);
    return NextResponse.json({ error: 'Error loading preview' }, { status: 500 });
  }
}