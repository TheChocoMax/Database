-- =====================================
-- SAMPLE DATA FOR CATEGORIES, ATTRIBUTES & TAGS SYSTEM
-- Replace/extend your seed_data.sql file with this data
-- =====================================

-- Insert languages first
INSERT INTO languages (iso_code, english_name, native_name)
VALUES ('fr', 'French', 'Français'), ('en', 'English', 'English'), ('es', 'Spanish', 'Español');

-- 1. INSERT PRODUCT CATEGORIES (main grouping)
INSERT INTO product_categories (category_name, category_color, category_description, display_order) VALUES
('Gâteaux', '#FF6B6B', 'Birthday cakes and celebration treats', 1),
('Viennoiseries', '#96CEB4', 'French pastries and croissants', 2),
('Chocolat', '#4ECDC4', 'Chocolate products and spreads', 3),
('Bouchées', '#45B7D1', 'Small bite-sized treats', 4),
('Pain', '#DDA0DD', 'Breads and traditional baked goods', 5);

-- 2. INSERT PRODUCT TAGS (marketing/seasonal)
INSERT INTO product_tags (tag_name, tag_color, tag_description, display_order) VALUES
('Bestseller', '#FFD700', 'Most popular products', 1),
('Seasonal', '#FF7675', 'Limited time seasonal items', 2),
('Valentine''s Day', '#E84393', 'Perfect for Valentine''s Day', 3),
('Birthday', '#6C5CE7', 'Perfect for birthdays', 4),
('Wedding', '#A29BFE', 'Elegant wedding treats', 5),
('Christmas', '#00B894', 'Holiday specialties', 6),
('New', '#00CEC9', 'Recently added products', 7);

-- 3. INSERT SAMPLE PRODUCTS WITH NEW STRUCTURE

-- Variant-based product (Macarons - quantity pricing)
INSERT INTO products (
    category_id,
    product_name,
    product_description,
    product_type,
    price,
    preparation_time_hours,
    serving_info,
    is_customizable
) VALUES (
    4, -- Bouchées category
    'Macarons Assortis',
    'Assortment of colorful French macarons in various flavors',
    'variant_based',
    NULL,
    24,
    'per piece',
    FALSE
);

-- Product variants for macarons
INSERT INTO product_variants (product_id, variant_name, quantity, price_override, is_default, display_order) VALUES
(1, '6 pièces', 6, 12.00, TRUE, 1),
(1, '12 pièces', 12, 20.00, FALSE, 2),
(1, '24 pièces', 24, 35.00, FALSE, 3);

-- Configurable product (Custom Chocolate Cake)
INSERT INTO products (
    category_id,
    product_name,
    product_description,
    product_type,
    base_price,
    preparation_time_hours,
    min_order_hours,
    serving_info,
    is_customizable
) VALUES (
    1, -- Gâteaux category
    'Gâteau Chocolat Personnalisé',
    'Custom chocolate cake with your choice of cream and decorations',
    'configurable',
    25.00,
    48,
    48,
    '4-8 persons',
    TRUE
);

-- Standard product (Chocolate Paste)
INSERT INTO products (
    category_id,
    product_name,
    product_description,
    product_type,
    price,
    preparation_time_hours,
    serving_info,
    is_customizable
) VALUES (
    3, -- Chocolat category
    'Pâte à Tartiner Chocolat',
    'Rich and indulgent chocolate spread made from the finest ingredients',
    'standard',
    8.50,
    24,
    '250g jar',
    FALSE
);

-- Standard product (Croissant)
INSERT INTO products (
    category_id,
    product_name,
    product_description,
    product_type,
    price,
    preparation_time_hours,
    serving_info,
    is_customizable
) VALUES (
    2, -- Viennoiseries category
    'Croissant Beurre',
    'Traditional French butter croissant, flaky and buttery',
    'standard',
    3.50,
    12,
    '1 piece',
    FALSE
);

-- 4. INSERT PRODUCT ATTRIBUTES (structured data)

-- Allergen attributes
INSERT INTO product_attributes (product_id, attribute_name, attribute_value, attribute_color) VALUES
-- Macarons allergens
(1, 'allergen', 'gluten', '#FF6B6B'),
(1, 'allergen', 'dairy', '#4ECDC4'),
(1, 'allergen', 'eggs', '#FFEAA7'),
(1, 'allergen', 'nuts', '#DDA0DD'),

-- Custom cake allergens
(2, 'allergen', 'gluten', '#FF6B6B'),
(2, 'allergen', 'dairy', '#4ECDC4'),
(2, 'allergen', 'eggs', '#FFEAA7'),

-- Chocolate spread allergens
(3, 'allergen', 'dairy', '#4ECDC4'),
(3, 'allergen', 'nuts', '#DDA0DD'),

-- Croissant allergens
(4, 'allergen', 'gluten', '#FF6B6B'),
(4, 'allergen', 'dairy', '#4ECDC4');

-- Flavor attributes
INSERT INTO product_attributes (product_id, attribute_name, attribute_value, attribute_color) VALUES
(1, 'flavor', 'vanilla', '#F8F8F8'),
(1, 'flavor', 'chocolate', '#8B4513'),
(1, 'flavor', 'strawberry', '#FF69B4'),
(1, 'flavor', 'pistachio', '#9ACD32'),
(2, 'flavor', 'chocolate', '#8B4513'),
(3, 'flavor', 'chocolate', '#8B4513'),
(4, 'flavor', 'butter', '#FFE4B5');

-- Dietary attributes
INSERT INTO product_attributes (product_id, attribute_name, attribute_value, attribute_color) VALUES
(3, 'dietary', 'vegetarian', '#32CD32');

-- Portion attributes
INSERT INTO product_attributes (product_id, attribute_name, attribute_value, attribute_color) VALUES
(1, 'portion', 'individual', '#87CEEB'),
(2, 'portion', 'sharing', '#FF7F50'),
(3, 'portion', 'family', '#DDA0DD'),
(4, 'portion', 'individual', '#87CEEB');

-- 5. ASSIGN TAGS TO PRODUCTS
INSERT INTO product_tag_assignments (product_id, product_tag_id) VALUES
-- Macarons
(1, 1), -- Bestseller
(1, 4), -- Birthday

-- Custom cake
(2, 4), -- Birthday
(2, 5), -- Wedding
(2, 7), -- New

-- Chocolate spread
(3, 1), -- Bestseller

-- Croissant
(4, 1), -- Bestseller
(4, 7); -- New

-- 6. INSERT CUSTOMIZATION OPTIONS FOR CONFIGURABLE PRODUCTS

INSERT INTO customization_options (option_name, option_type, is_required, display_order) VALUES
('Type de crème', 'single_select', TRUE, 1),
('Décoration', 'single_select', FALSE, 2),
('Taille', 'single_select', TRUE, 3),
('Message personnalisé', 'text_input', FALSE, 4);

-- Cream type options
INSERT INTO customization_option_values (customization_option_id, value_name, price_modifier, is_default, display_order) VALUES
(1, 'Crème au chocolat', 0.00, TRUE, 1),
(1, 'Crème vanille', 2.00, FALSE, 2),
(1, 'Crème caramel', 3.00, FALSE, 3),
(1, 'Crème fruits rouges', 4.00, FALSE, 4);

-- Decoration options
INSERT INTO customization_option_values (customization_option_id, value_name, price_modifier, is_default, display_order) VALUES
(2, 'Décoration simple', 0.00, TRUE, 1),
(2, 'Fleurs en sucre', 8.00, FALSE, 2),
(2, 'Figurines chocolat', 12.00, FALSE, 3),
(2, 'Décoration premium', 15.00, FALSE, 4);

-- Size options
INSERT INTO customization_option_values (customization_option_id, value_name, price_modifier, is_default, display_order) VALUES
(3, '4 personnes', 0.00, TRUE, 1),
(3, '6 personnes', 8.00, FALSE, 2),
(3, '8 personnes', 15.00, FALSE, 3),
(3, '10 personnes', 22.00, FALSE, 4);

-- Link customization options to the configurable cake product
INSERT INTO product_customization_options (product_id, customization_option_id, is_required, display_order) VALUES
(2, 1, TRUE, 1),  -- Cream type is required
(2, 2, FALSE, 2), -- Decoration is optional
(2, 3, TRUE, 3),  -- Size is required
(2, 4, FALSE, 4); -- Message is optional

-- 7. ADD TRANSLATIONS FOR NEW CONTENT

-- Category translations
INSERT INTO category_translations (category_id, language_id, category_name, category_description) VALUES
-- French translations (language_id = 1)
(1, 1, 'Gâteaux', 'Gâteaux d''anniversaire et de célébration'),
(2, 1, 'Viennoiseries', 'Pâtisseries françaises et croissants'),
(3, 1, 'Chocolat', 'Produits chocolatés et pâtes à tartiner'),
(4, 1, 'Bouchées', 'Petites gourmandises à déguster'),
(5, 1, 'Pain', 'Pains et produits de boulangerie traditionnels'),

-- English translations (language_id = 2)
(1, 2, 'Cakes', 'Birthday cakes and celebration treats'),
(2, 2, 'Pastries', 'French pastries and croissants'),
(3, 2, 'Chocolate', 'Chocolate products and spreads'),
(4, 2, 'Bite-sized Treats', 'Small bite-sized treats'),
(5, 2, 'Bread', 'Breads and traditional baked goods'),

-- Spanish translations (language_id = 3)
(1, 3, 'Pasteles', 'Pasteles de cumpleaños y celebración'),
(2, 3, 'Bollería', 'Bollería francesa y croissants'),
(3, 3, 'Chocolate', 'Productos de chocolate y cremas'),
(4, 3, 'Bocados', 'Pequeños bocados deliciosos'),
(5, 3, 'Pan', 'Panes y productos de panadería tradicionales');

-- Tag translations
INSERT INTO product_tag_translations (product_tag_id, language_id, tag_name, tag_description) VALUES
-- French translations
(1, 1, 'Bestseller', 'Produits les plus populaires'),
(2, 1, 'Saisonnier', 'Articles saisonniers à durée limitée'),
(3, 1, 'Saint-Valentin', 'Parfait pour la Saint-Valentin'),
(4, 1, 'Anniversaire', 'Parfait pour les anniversaires'),
(5, 1, 'Mariage', 'Friandises élégantes pour mariage'),
(6, 1, 'Noël', 'Spécialités des fêtes'),
(7, 1, 'Nouveau', 'Produits récemment ajoutés'),

-- English translations
(1, 2, 'Bestseller', 'Most popular products'),
(2, 2, 'Seasonal', 'Limited time seasonal items'),
(3, 2, 'Valentine''s Day', 'Perfect for Valentine''s Day'),
(4, 2, 'Birthday', 'Perfect for birthdays'),
(5, 2, 'Wedding', 'Elegant wedding treats'),
(6, 2, 'Christmas', 'Holiday specialties'),
(7, 2, 'New', 'Recently added products');

-- Product translations
INSERT INTO product_translations (product_id, language_id, product_name, product_description) VALUES
-- English translations
(1, 2, 'Assorted Macarons', 'Assortment of colorful French macarons in various flavors'),
(2, 2, 'Custom Chocolate Cake', 'Custom chocolate cake with your choice of cream and decorations'),
(3, 2, 'Chocolate Spread', 'Rich and indulgent chocolate spread made from the finest ingredients'),
(4, 2, 'Butter Croissant', 'Traditional French butter croissant, flaky and buttery'),

-- Spanish translations
(1, 3, 'Macarons Surtidos', 'Surtido de macarons franceses coloridos en varios sabores'),
(2, 3, 'Pastel de Chocolate Personalizado', 'Pastel de chocolate personalizado con tu elección de crema y decoraciones'),
(3, 3, 'Crema de Chocolate', 'Rica y deliciosa crema de chocolate hecha con los mejores ingredientes'),
(4, 3, 'Croissant de Mantequilla', 'Croissant francés tradicional de mantequilla, hojaldrado y mantecoso');

-- Customization option translations
INSERT INTO customization_option_translations (customization_option_id, language_id, option_name) VALUES
-- French (already in base data)
-- English
(1, 2, 'Cream Type'), (2, 2, 'Decoration'), (3, 2, 'Size'), (4, 2, 'Personal Message'),
-- Spanish
(1, 3, 'Tipo de Crema'), (2, 3, 'Decoración'), (3, 3, 'Tamaño'), (4, 3, 'Mensaje Personalizado');

-- Customization option value translations
INSERT INTO customization_option_value_translations (option_value_id, language_id, value_name) VALUES
-- Cream types - English
(1, 2, 'Chocolate Cream'), (2, 2, 'Vanilla Cream'), (3, 2, 'Caramel Cream'), (4, 2, 'Berry Cream'),
-- Cream types - Spanish
(1, 3, 'Crema de Chocolate'), (2, 3, 'Crema de Vainilla'), (3, 3, 'Crema de Caramelo'), (4, 3, 'Crema de Frutos Rojos'),

-- Decorations - English
(5, 2, 'Simple Decoration'), (6, 2, 'Sugar Flowers'), (7, 2, 'Chocolate Figurines'), (8, 2, 'Premium Decoration'),
-- Decorations - Spanish
(5, 3, 'Decoración Simple'), (6, 3, 'Flores de Azúcar'), (7, 3, 'Figuras de Chocolate'), (8, 3, 'Decoración Premium'),

-- Sizes - English
(9, 2, '4 people'), (10, 2, '6 people'), (11, 2, '8 people'), (12, 2, '10 people'),
-- Sizes - Spanish
(9, 3, '4 personas'), (10, 3, '6 personas'), (11, 3, '8 personas'), (12, 3, '10 personas');
