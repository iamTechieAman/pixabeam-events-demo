# PixaBeam Assessment Deliverables

## Part 1 – Database
- Schema SQL: `supabase/schema.sql`
- ER Diagram: `supabase/ER.md` (Mermaid) and `supabase/er.mmd`
- Design notes: `supabase/DESIGN.md`
- Screenshots to attach (capture from Supabase):
  - Tables list
  - Row data in each table
  - ER diagram screenshot (rendered from the Mermaid block)
  - SQL editor after running seed

## Part 2 – App
- App code: `pixabeam-events/`
- Live link: (to be added after Vercel deploy)
- GitHub repo: (to be added after push)
- README: `pixabeam-events/README.md`

## How to Export Schema Dump
1. In Supabase → SQL editor, run the seed and ensure tables exist.
2. Using local `pg_dump` with your project connection string:
```
PGPASSWORD=your_password pg_dump \
  --clean --if-exists \
  --schema=public \
  --dbname="postgresql://postgres:your_password@db.YOURHOST.supabase.co:5432/postgres" \
  > supabase/schema_dump.sql
```
3. Or use Supabase Studio: Database → Backups → Download (if available).
