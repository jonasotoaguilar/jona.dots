# SEO and AI Search Guidelines for UI Design

Use this reference when designing public pages, landing pages, content pages, docs, product pages, comparison pages, directories, or programmatic SEO templates.

## SEO Boundary

This skill covers SEO-sensitive UI and page structure during design. Hand off to dedicated SEO workflows for: deep keyword research, technical SEO audits, GEO/AI-search campaigns, backlink strategy, and programmatic SEO at scale. Do not turn every UI task into an SEO task; do not pick keywords or run audits here.

For site-wide runtime/SEO evidence across every page (performance, accessibility, SEO, best-practices scans), route to the `unlighthouse` skill — it owns the measured scan and report; this file owns the design contract the scan verifies against.

## Page Structure

- One clear H1 per page.
- H2/H3 headings must describe content, not just style sections.
- Lead key sections with the answer or value proposition.
- Use short paragraphs, lists, tables, and comparison blocks for scanability.
- Match structure to search intent: learn, compare, buy, navigate, troubleshoot, or evaluate.
- Keep important content renderable/indexable; avoid hiding core copy behind client-only interactions.

## Metadata and Sharing

- Unique title: 50–60 characters when possible.
- Unique meta description: 150–160 characters when possible.
- Canonical URL for indexable pages.
- Open Graph and Twitter card metadata for shareable pages.
- Descriptive image alt text; keywords only when natural.

## Structured Data

- Use schema only when visible content supports it.
- Common schemas: `WebPage`, `Organization`, `Article`, `Product`, `FAQPage`, `BreadcrumbList`.
- Add FAQ schema only for real FAQ content visible on the page.
- Use breadcrumbs with structured data for deep hierarchies.

## GEO / AI Extractability

- Make answer blocks self-contained; they should make sense without surrounding context.
- For “what is” intent, include a direct definition near the top.
- For “how to” intent, use ordered steps.
- For “X vs Y” intent, use comparison tables and a short verdict.
- Add credible stats, citations, and expert attribution when claims need authority.
- Avoid keyword stuffing; it hurts quality and AI visibility.

## Programmatic Page Design

- Every generated page must have unique value, not just swapped variables.
- Prefer subfolders over subdomains for SEO authority.
- Add related pages/internal links; avoid orphan pages.
- Include breadcrumbs and XML sitemap coverage for generated pages.
- Noindex thin or low-value variations.

## Performance and Crawlability

- Mobile-responsive design is mandatory; aim for LCP < 2.5s, INP/FID < 100ms, CLS < 0.1 (runtime measurement is `unlighthouse`'s job).
- Reserve image optimization (correct dimensions, modern formats, lazy loading below the fold) for the build phase; design only specifies aspect ratios, alt text, and critical vs. deferrable media.
- Avoid layout shifts from ads, fonts, images, or async content; keep navigation and internal links crawlable.

## SEO Design Checklist

- [ ] Page has one H1 and logical heading hierarchy.
- [ ] Title, description, canonical, and OG/Twitter metadata are planned.
- [ ] Important content is visible, indexable, and matches search intent.
- [ ] Internal links and breadcrumbs support discovery.
- [ ] Images have meaningful alt text and a defined loading strategy (deferrable vs. critical).
- [ ] Structured data matches visible content.
- [ ] AI-answerable sections use direct answers, tables, steps, FAQs, or cited stats.
- [ ] Core Web Vitals risks are addressed in the design.
