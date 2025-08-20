export const dynamic = 'force-dynamic';
import Link from 'next/link';
import { getSupabaseServerClient } from './lib/supabaseServer';
import type { DbEvent } from './types';

export default function Home() {
  return <EventsList />;
}

async function EventsList() {
  const supabase = getSupabaseServerClient();
  const { data, error } = await supabase
    .from('events')
    .select('id, title, description, date, city')
    .gte('date', new Date().toISOString())
    .order('date', { ascending: true });
  if (error) {
    return <main className="p-8"><h1 className="text-2xl font-semibold">Upcoming Events</h1><p className="mt-4 text-red-600">Failed to load events: {error.message}</p></main>;
  }
  const events = (data ?? []) as DbEvent[];
  return (
    <main className="p-8 max-w-3xl mx-auto">
      <h1 className="text-3xl font-bold">Upcoming Events</h1>
      <ul className="mt-6 space-y-4">
        {events.map((event) => (
          <li key={event.id} className="border rounded p-4">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-xl font-semibold">{event.title}</h2>
                <p className="text-sm text-gray-600">{new Date(event.date).toLocaleString()} — {event.city}</p>
              </div>
              <Link className="text-blue-600 underline" href={`/events/${event.id}`}>RSVP</Link>
            </div>
            {event.description && (
              <p className="mt-2 text-gray-800">{event.description}</p>
            )}
          </li>
        ))}
      </ul>
    </main>
  );
}
