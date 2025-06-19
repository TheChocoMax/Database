CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(48);

-- Verify that the schema has the expected types

SELECT has_type('delivery_type', 'Type exists');
SELECT has_type('order_status', 'Type exists');
SELECT has_type('payment_status', 'Type exists');
SELECT has_type('authentication_method', 'Type exists');
SELECT has_type('moderation_action_type', 'Type exists');
SELECT has_type('moderation_target_type', 'Type exists');
SELECT has_type('discount_type', 'Type exists');
SELECT has_type('promotion_type', 'Type exists');
SELECT has_type('admin_account_role', 'Type exists');
SELECT has_type('admin_action_target_type', 'Type exists');

-- Verify that the schema has the expected tables

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
SELECT has_table('order_delivery_informations', 'Table exists');
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

-- Verify that the schema has the expected indexes

SELECT has_index('users', 'idx_users_email_hash', 'Index exists');
SELECT has_index('user_sessions', 'idx_user_sessions_token', 'Index exists');
SELECT has_index('login_attempts', 'idx_login_attempts_user_id', 'Index exists');
SELECT has_index('metrics_events', 'idx_metrics_events_event_type', 'Index exists');

SELECT finish(TRUE);

ROLLBACK;
