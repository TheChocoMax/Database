CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(34);

SELECT has_table('users', 'Table exists');
SELECT has_table('user_permissions', 'Table exists');
SELECT has_table('user_sessions', 'Table exists');
SELECT has_table('email_verifications', 'Table exists');
SELECT has_table('password_resets', 'Table exists');
SELECT has_table('user_authentication_methods', 'Table exists');
SELECT has_table('login_attempts', 'Table exists');
SELECT has_table('products', 'Table exists');
SELECT has_table('product_categories', 'Table exists');
SELECT has_table('product_variants', 'Table exists');
SELECT has_table('product_images', 'Table exists');
SELECT has_table('product_likes', 'Table exists');
SELECT has_table('product_comments', 'Table exists');
SELECT has_table('moderation_actions', 'Table exists');
SELECT has_table('carts', 'Table exists');
SELECT has_table('cart_items', 'Table exists');
SELECT has_table('orders', 'Table exists');
SELECT has_table('order_items', 'Table exists');
SELECT has_table('order_status_histories', 'Table exists');
SELECT has_table('order_delivery_infos', 'Table exists');
SELECT has_table('order_timestamps', 'Table exists');
SELECT has_table('discount_codes', 'Table exists');
SELECT has_table('user_discounts', 'Table exists');
SELECT has_table('loyalty_programs', 'Table exists');
SELECT has_table('user_loyalty_progress', 'Table exists');
SELECT has_table('languages', 'Table exists');
SELECT has_table('translations', 'Table exists');
SELECT has_table('product_translations', 'Table exists');
SELECT has_table('category_translations', 'Table exists');
SELECT has_table('metrics_events', 'Table exists');
SELECT has_table('admin_accounts', 'Table exists');
SELECT has_table('admin_actions', 'Table exists');
SELECT has_table('contact_messages', 'Table exists');
SELECT has_table('feedbacks', 'Table exists');

SELECT finish(TRUE);

ROLLBACK;
