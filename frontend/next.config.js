/** @type {import('next').NextConfig} */
const nextConfig = {
  trailingSlash: true,
  images: {
    domains: [process.env.WORDPRESS_API_URL?.replace(/^https?:\/\//, '') || 'localhost']
  },
  env: {
    WORDPRESS_API_URL: process.env.WORDPRESS_API_URL || 'http://localhost/wp-json/wp/v2'
  }
}

module.exports = nextConfig