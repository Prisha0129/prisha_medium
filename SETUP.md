# Secure cloud setup

The site is now prepared for Supabase. Do **not** send your password to anyone, including me.

1. Create a free project at [Supabase](https://supabase.com/dashboard).
2. In its **SQL Editor**, run all of `supabase-setup.sql`.
3. In **Project Settings → API**, copy the Project URL and the publishable (or anon) key into `supabase-config.js`. The browser key is intentionally public; it cannot bypass the security rules.
4. In **Authentication → URL Configuration**, add your GitHub Pages address as the Site URL and Redirect URL. For example: `https://YOUR-GITHUB-NAME.github.io/YOUR-REPOSITORY/`.
5. Publish the site to GitHub Pages. Open it, enter your email and a new strong password, then click **Create account**. Confirm the email sent by Supabase.
6. Back in Supabase SQL Editor, run the final commented `insert` command at the bottom of `supabase-setup.sql`, replacing `YOUR_EMAIL@example.com` with your email. This makes only your account an editor.
7. Sign in. You can now publish, update, archive, and delete journals. Changes and new photos are saved in the cloud and show to every visitor.

Use a unique password of at least 14 characters (a password manager-generated password is ideal). Your password is entered only on the website's sign-up/sign-in form and is securely handled by Supabase; it is never saved in this repository.
