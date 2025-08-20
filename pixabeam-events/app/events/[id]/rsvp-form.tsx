'use client';

import { useState, useTransition } from 'react';
import { getSupabaseBrowserClient } from '@/app/lib/supabaseBrowser';
import type { RsvpStatus } from '@/app/types';

export function RsvpForm({ eventId }: { eventId: string }) {
  const supabase = getSupabaseBrowserClient();
  const [status, setStatus] = useState<RsvpStatus>('Yes');
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [message, setMessage] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setMessage(null);

    if (!email || !name) {
      setMessage('Please provide your name and email.');
      return;
    }

    // Find or create user by email
    const { data: existingUser, error: findErr } = await supabase
      .from('users')
      .select('id')
      .eq('email', email)
      .maybeSingle();
    if (findErr) {
      setMessage(`Error looking up user: ${findErr.message}`);
      return;
    }

    let userId = existingUser?.id as string | undefined;
    if (!userId) {
      const { data: newUser, error: insertErr } = await supabase
        .from('users')
        .insert({ name, email })
        .select('id')
        .single();
      if (insertErr) {
        setMessage(`Error creating user: ${insertErr.message}`);
        return;
      }
      userId = newUser.id as string;
    }

    startTransition(async () => {
      const { error: upsertErr } = await supabase
        .from('rsvps')
        .upsert({ user_id: userId, event_id: eventId, status }, { onConflict: 'user_id,event_id' });
      if (upsertErr) {
        setMessage(`Error saving RSVP: ${upsertErr.message}`);
      } else {
        setMessage('Your RSVP has been saved.');
      }
    });
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="flex gap-2">
        <input
          type="text"
          placeholder="Your name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          className="border rounded p-2 flex-1"
          required
        />
        <input
          type="email"
          placeholder="your@email.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="border rounded p-2 flex-1"
          required
        />
      </div>

      <div className="flex gap-4 items-center">
        <label className="flex items-center gap-1">
          <input type="radio" name="status" checked={status === 'Yes'} onChange={() => setStatus('Yes')} /> Yes
        </label>
        <label className="flex items-center gap-1">
          <input type="radio" name="status" checked={status === 'No'} onChange={() => setStatus('No')} /> No
        </label>
        <label className="flex items-center gap-1">
          <input type="radio" name="status" checked={status === 'Maybe'} onChange={() => setStatus('Maybe')} /> Maybe
        </label>
      </div>

      <button type="submit" disabled={isPending} className="px-4 py-2 bg-blue-600 text-white rounded disabled:opacity-50">
        {isPending ? 'Saving…' : 'Save RSVP'}
      </button>
      {message && <p className="text-sm mt-2">{message}</p>}
    </form>
  );
}


