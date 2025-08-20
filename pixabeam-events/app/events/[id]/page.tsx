export const dynamic = 'force-dynamic';
import { getSupabaseServerClient } from '@/app/lib/supabaseServer';
import { RsvpForm } from './rsvp-form';
import type { DbEvent } from '@/app/types';

interface PageProps {
  params: Promise<{ id: string }>;
}

export default async function EventPage({ params }: PageProps) {
  const { id } = await params;
  const supabase = getSupabaseServerClient();
  const { data, error } = await supabase
    .from('events')
    .select('id, title, description, date, city')
    .eq('id', id)
    .single();

  if (error || !data) {
    return <main className="p-8 max-w-2xl mx-auto"><p className="text-red-600">Event not found.</p></main>;
  }
  const event = data as DbEvent;
  return (
    <main className="p-8 max-w-2xl mx-auto space-y-4">
      <h1 className="text-3xl font-bold">{event.title}</h1>
      <p className="text-gray-600">{new Date(event.date).toLocaleString()} — {event.city}</p>
      {event.description && <p className="text-gray-800">{event.description}</p>}
      <section className="mt-6">
        <h2 className="text-xl font-semibold mb-2">RSVP</h2>
        <RsvpForm eventId={event.id} />
      </section>
    </main>
  );
}


