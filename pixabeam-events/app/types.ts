export type RsvpStatus = 'Yes' | 'No' | 'Maybe';

export interface DbUser {
  id: string;
  name: string;
  email: string;
}

export interface DbEvent {
  id: string;
  title: string;
  description: string | null;
  date: string; // ISO string
  city: string;
  created_by: string | null;
}

export interface DbRsvp {
  id: string;
  user_id: string;
  event_id: string;
  status: RsvpStatus;
}


