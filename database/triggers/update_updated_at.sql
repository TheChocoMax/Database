CREATE TRIGGER tr_set_updated_at_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_user_sessions
BEFORE UPDATE ON user_sessions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_email_verifications
BEFORE UPDATE ON email_verifications
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_password_resets
BEFORE UPDATE ON password_resets
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_user_authentication_methods
BEFORE UPDATE ON user_authentication_methods
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_products
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_product_categories
BEFORE UPDATE ON product_categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_product_variants
BEFORE UPDATE ON product_variants
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_product_images
BEFORE UPDATE ON product_images
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_product_likes
BEFORE UPDATE ON product_likes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_product_comments
BEFORE UPDATE ON product_comments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_moderation_actions
BEFORE UPDATE ON moderation_actions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_carts
BEFORE UPDATE ON carts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_cart_items
BEFORE UPDATE ON cart_items
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_orders
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_order_items
BEFORE UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_order_status_histories
BEFORE UPDATE ON order_status_histories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_order_delivery_informations
BEFORE UPDATE ON order_delivery_informations
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_order_timestamps
BEFORE UPDATE ON order_timestamps
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_discount_codes
BEFORE UPDATE ON discount_codes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_user_discounts
BEFORE UPDATE ON user_discounts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_loyalty_programs
BEFORE UPDATE ON loyalty_programs
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_user_loyalty_progress
BEFORE UPDATE ON user_loyalty_progress
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_translations
BEFORE UPDATE ON translations
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_product_translations
BEFORE UPDATE ON product_translations
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_category_translations
BEFORE UPDATE ON category_translations
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_metrics_events
BEFORE UPDATE ON metrics_events
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_admin_accounts
BEFORE UPDATE ON admin_accounts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_admin_actions
BEFORE UPDATE ON admin_actions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_contact_messages
BEFORE UPDATE ON contact_messages
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_set_updated_at_feedbacks
BEFORE UPDATE ON feedbacks
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
