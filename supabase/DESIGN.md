# Design Choices

- Users
  - UUID primary key for scalability and client-side generation.
  - Unique email constraint to ensure one account per email.
- Events
  - `created_by` nullable with `ON DELETE SET NULL` so deleting a user doesn't erase their events history.
  - Index on `date` for upcoming events queries.
- RSVPs
  - Composite uniqueness (`user_id`, `event_id`) to prevent duplicates.
  - Enum `rsvp_status` with values Yes/No/Maybe.
  - `ON DELETE CASCADE` from both users and events to auto-cleanup.

## Referential Integrity
- Delete user → cascade delete their rsvps; events remain but `created_by` becomes NULL.
- Delete event → cascade delete its rsvps.

## App Flow (No Auth)
- User provides name+email on RSVP; if email not found, we create the user.
- RSVP upsert enforces one response per user per event.
