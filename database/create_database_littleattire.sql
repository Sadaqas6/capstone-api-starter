USE sys;

# ---------------------------------------------------------------------- #
# Target DBMS:           MySQL                                           #
# Project name:          LittleAttire (Luxury Baby Clothing)             #
# ---------------------------------------------------------------------- #

DROP DATABASE IF EXISTS littleattire;

CREATE DATABASE IF NOT EXISTS littleattire;

USE littleattire;

# ---------------------------------------------------------------------- #
# Tables                                                                 #
# ---------------------------------------------------------------------- #

CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE profiles (
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(200) NOT NULL,
    address VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip VARCHAR(20) NOT NULL,
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE categories (
    category_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    PRIMARY KEY (category_id)
);

CREATE TABLE products (
    product_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,
    description TEXT,
    subcategory VARCHAR(20),
    image_url VARCHAR(200),
    stock INT NOT NULL DEFAULT 0,
    featured BOOL NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    date DATETIME NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip VARCHAR(20) NOT NULL,
    shipping_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_line_items (
    order_line_item_id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    sales_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_line_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- new tables
CREATE TABLE shopping_cart (
    cart_item_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (cart_item_id),
    UNIQUE KEY uq_cart_user_product (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

/* INSERT Users */
INSERT INTO users (username, hashed_password, role)
VALUES
    ('user','$2a$10$NkufUPF3V8dEPSZeo1fzHe9ScBu.LOay9S3N32M84yuUM2OJYEJ/.','ROLE_USER'),
    ('admin','$2a$10$lfQi9jSfhZZhfS6/Kyzv3u3418IgnWXWDQDk7IbcwlCFPgxg9Iud2','ROLE_ADMIN'),
    ('george','$2a$10$lfQi9jSfhZZhfS6/Kyzv3u3418IgnWXWDQDk7IbcwlCFPgxg9Iud2','ROLE_USER');

/* INSERT Profiles */
INSERT INTO profiles (user_id, first_name, last_name, phone, email, address, city, state, zip)
VALUES
    (1, 'Joe', 'Joesephus', '800-555-1234', 'joejoesephus@email.com', '789 Oak Avenue', 'Dallas', 'TX', '75051'),
    (2, 'Adam', 'Admamson', '800-555-1212', 'aaadamson@email.com', '456 Elm Street', 'Dallas', 'TX', '75052'),
    (3, 'George', 'Jetson', '800-555-9876', 'george.jetson@email.com', '123 Birch Parkway', 'Dallas', 'TX', '75051');

/* INSERT Categories */
INSERT INTO categories (name, description)
VALUES
    ('Onesies & Bodysuits', 'Premium organic cotton and silk-blend onesies and bodysuits for everyday luxury.'),
    ('Outerwear & Sets', 'Cashmere, merino wool, and tailored knit sets, sweaters, and jackets for baby.'),
    ('Footwear & Accessories', 'Hand-stitched booties, leather pram shoes, bonnets, and luxury accessories.');

/* INSERT Products */
-- Onesies & Bodysuits (Category 1)
INSERT INTO products (name, price, category_id, description, image_url, stock, featured, subcategory)
VALUES
    ('Organic Cotton Ribbed Onesie', 39.99, 1, 'Buttery-soft GOTS-certified organic cotton onesie with mother-of-pearl snaps.', 'organic-ribbed-onesie.jpg', 50, 1, 'Ivory'),
    ('Silk-Blend Short Sleeve Bodysuit', 64.99, 1, 'Luxurious silk-cotton blend bodysuit with hand-finished seams.', 'silk-bodysuit.jpg', 30, 1, 'Blush'),
    ('Pima Cotton Long Sleeve Onesie', 44.99, 1, 'Ultra-fine Peruvian Pima cotton for everyday softness.', 'pima-onesie.jpg', 45, 0, 'White'),
    ('Embroidered Linen Bodysuit', 59.99, 1, 'Breathable linen bodysuit with delicate hand embroidery.', 'linen-embroidered-bodysuit.jpg', 25, 0, 'Sage'),
    ('Bamboo Jersey Onesie', 34.99, 1, 'Thermoregulating bamboo jersey, gentle on sensitive skin.', 'bamboo-onesie.jpg', 60, 0, 'Oat'),
    ('Heirloom Gown Bodysuit', 79.99, 1, 'Classic gown-style bodysuit with scalloped trim, perfect for special occasions.', 'heirloom-gown.jpg', 20, 1, 'Cream'),
    ('Cotton Sateen Footed Onesie', 49.99, 1, 'Smooth sateen finish with footed design for cozy warmth.', 'sateen-footed-onesie.jpg', 40, 0, 'Powder Blue'),
    ('Ruffle Trim Bodysuit', 42.99, 1, 'Soft cotton bodysuit with delicate ruffle detailing.', 'ruffle-bodysuit.jpg', 35, 0, 'Pink'),
    ('Modal Stretch Onesie', 36.99, 1, 'Featherlight modal fabric with four-way stretch.', 'modal-onesie.jpg', 55, 0, 'Heather Gray'),
    ('Hand-Smocked Bodysuit', 69.99, 1, 'Traditional hand-smocked detailing on premium cotton.', 'smocked-bodysuit.jpg', 18, 1, 'Yellow'),
    ('Striped Cotton Onesie Set', 47.99, 1, 'Classic breton stripe onesie, set of two.', 'striped-onesie-set.jpg', 40, 0, 'Navy'),
    ('Velvet Trim Holiday Bodysuit', 74.99, 1, 'Festive bodysuit with plush velvet trim accents.', 'velvet-holiday-bodysuit.jpg', 15, 0, 'Red'),
    ('Muslin Layer Onesie', 41.99, 1, 'Double-layer cotton muslin for breathable comfort.', 'muslin-onesie.jpg', 30, 0, 'Taupe'),
    ('Cashmere-Blend Bodysuit', 89.99, 1, 'A rare cashmere-cotton blend bodysuit for ultimate softness.', 'cashmere-bodysuit.jpg', 12, 1, 'Camel'),
    ('Lace-Trim Cotton Onesie', 52.99, 1, 'Delicate French lace trim on soft cotton base.', 'lace-trim-onesie.jpg', 22, 0, 'White'),
    ('Floral Print Bodysuit', 46.99, 1, 'Watercolor floral print on organic cotton.', 'floral-bodysuit.jpg', 28, 0, 'Multi'),
    ('Waffle Knit Onesie', 38.99, 1, 'Textured waffle knit cotton for everyday wear.', 'waffle-onesie.jpg', 38, 0, 'Sage'),
    ('Satin Bow Bodysuit', 54.99, 1, 'Cotton bodysuit finished with a hand-tied satin bow.', 'satin-bow-bodysuit.jpg', 24, 0, 'Blush');

-- Outerwear & Sets (Category 2)
INSERT INTO products (name, price, category_id, description, image_url, stock, featured, subcategory)
VALUES
    ('Cashmere Knit Cardigan', 129.99, 2, '100% baby cashmere cardigan, hand-finished buttons.', 'cashmere-cardigan.jpg', 20, 1, 'Cream'),
    ('Merino Wool Romper', 99.99, 2, 'Temperature-regulating merino wool romper.', 'merino-romper.jpg', 25, 1, 'Charcoal'),
    ('Quilted Pram Coat', 149.99, 2, 'Tailored quilted coat with satin lining for outings.', 'quilted-pram-coat.jpg', 15, 1, 'Camel'),
    ('Organic Cotton Knit Set', 84.99, 2, 'Two-piece knit top and pant set in organic cotton.', 'cotton-knit-set.jpg', 30, 0, 'Oat'),
    ('Velour Tracksuit Set', 74.99, 2, 'Plush velour zip-up and pant set.', 'velour-tracksuit.jpg', 28, 0, 'Dusty Rose'),
    ('Fleece-Lined Snowsuit', 119.99, 2, 'Insulated snowsuit with fleece lining for cold weather.', 'fleece-snowsuit.jpg', 18, 0, 'Navy'),
    ('Wool Blend Overcoat', 134.99, 2, 'Structured wool-blend overcoat with horn buttons.', 'wool-overcoat.jpg', 12, 1, 'Gray'),
    ('Linen Romper Set', 69.99, 2, 'Breathable linen romper with matching headband.', 'linen-romper-set.jpg', 22, 0, 'White'),
    ('Cable Knit Sweater', 64.99, 2, 'Classic cable knit pullover sweater.', 'cable-knit-sweater.jpg', 35, 0, 'Ivory'),
    ('Quilted Vest', 54.99, 2, 'Lightweight quilted vest for layering.', 'quilted-vest.jpg', 30, 0, 'Olive'),
    ('Silk-Lined Christening Set', 159.99, 2, 'Heirloom-quality silk-lined gown and bonnet set.', 'christening-set.jpg', 10, 1, 'White'),
    ('Knit Overall Set', 79.99, 2, 'Soft knit overalls paired with a long sleeve bodysuit.', 'knit-overall-set.jpg', 26, 0, 'Mustard'),
    ('Faux Shearling Jacket', 94.99, 2, 'Cozy faux shearling jacket with snap closures.', 'shearling-jacket.jpg', 16, 0, 'Tan'),
    ('Organic Fleece Onesie Set', 72.99, 2, 'Brushed organic fleece zip onesie, set of two.', 'fleece-onesie-set.jpg', 32, 0, 'Heather Blue'),
    ('Tailored Vest & Bowtie Set', 89.99, 2, 'Formal vest and bowtie set for special occasions.', 'vest-bowtie-set.jpg', 14, 0, 'Navy');

-- Footwear & Accessories (Category 3)
INSERT INTO products (name, price, category_id, description, image_url, stock, featured, subcategory)
VALUES
    ('Hand-Stitched Leather Booties', 59.99, 3, 'Soft sole leather booties, hand-stitched in Italy.', 'leather-booties.jpg', 30, 1, 'Tan'),
    ('Cashmere Knit Bonnet', 44.99, 3, 'Cozy cashmere bonnet with chin tie.', 'cashmere-bonnet.jpg', 25, 1, 'Cream'),
    ('Organic Cotton Mittens', 19.99, 3, 'Scratch-free mittens in soft organic cotton.', 'cotton-mittens.jpg', 50, 0, 'White'),
    ('Suede Pram Shoes', 54.99, 3, 'Lightweight suede shoes designed for pram outings.', 'suede-pram-shoes.jpg', 28, 1, 'Gray'),
    ('Merino Wool Booties', 39.99, 3, 'Warm merino wool booties with ribbed cuff.', 'merino-booties.jpg', 35, 0, 'Oat'),
    ('Silk Trim Headband', 24.99, 3, 'Soft cotton headband finished with a silk bow.', 'silk-headband.jpg', 40, 0, 'Blush'),
    ('Leather Sun Hat', 49.99, 3, 'Wide-brim leather-trimmed sun hat for outdoor protection.', 'leather-sun-hat.jpg', 20, 0, 'Camel'),
    ('Knit Bootie & Hat Set', 47.99, 3, 'Matching knit booties and hat gift set.', 'bootie-hat-set.jpg', 22, 1, 'Ivory'),
    ('Cotton Cable Knit Socks', 16.99, 3, 'Soft cable knit socks, pack of three.', 'cable-knit-socks.jpg', 60, 0, 'Multi'),
    ('Embroidered Linen Bib Set', 29.99, 3, 'Set of three embroidered linen bibs.', 'linen-bib-set.jpg', 45, 0, 'White'),
    ('Sherpa-Lined Booties', 42.99, 3, 'Plush sherpa-lined booties for cold days.', 'sherpa-booties.jpg', 24, 0, 'Gray'),
    ('Satin Christening Booties', 64.99, 3, 'Elegant satin booties to match the christening set.', 'satin-christening-booties.jpg', 12, 0, 'White'),
    ('Wool Beanie', 32.99, 3, 'Soft wool beanie with pom-pom detail.', 'wool-beanie.jpg', 30, 0, 'Mustard'),
    ('Leather Baby Moccasins', 49.99, 3, 'Flexible leather moccasins for first steps.', 'leather-moccasins.jpg', 26, 0, 'Brown'),
    ('Cotton Muslin Swaddle Set', 54.99, 3, 'Set of three breathable muslin swaddle blankets.', 'muslin-swaddle-set.jpg', 30, 1, 'Sage'),
    ('Velvet Bow Headband', 22.99, 3, 'Plush velvet bow headband for special occasions.', 'velvet-bow-headband.jpg', 35, 0, 'Burgundy'),
    ('Knit Pram Blanket', 79.99, 3, 'Soft knit blanket sized for prams and bassinets.', 'knit-pram-blanket.jpg', 18, 0, 'Cream'),
    ('Leather Teething Bracelet', 27.99, 3, 'Stylish silicone-and-leather teething accessory for parents.', 'teething-bracelet.jpg', 40, 0, 'Tan'),
    ('Cotton Knit Booties', 26.99, 3, 'Simple soft-sole knit booties for everyday wear.', 'cotton-knit-booties.jpg', 50, 0, 'Pink');

-- sample duplicates (mirrors original starter pattern -- relevant for search/filter bug testing)
INSERT INTO products (name, price, category_id, description, image_url, stock, featured, subcategory)
VALUES
    ('Organic Cotton Ribbed Onesie', 42.99, 1, 'Limited edition organic ribbed onesie in a new colorway.', 'organic-ribbed-onesie.jpg', 18, 0, 'Sage'),
    ('Cashmere Knit Cardigan', 134.99, 2, 'Cashmere cardigan in a different colorway.', 'cashmere-cardigan.jpg', 10, 0, 'Gray'),
    ('Hand-Stitched Leather Booties', 62.99, 3, 'Leather booties in a navy colorway.', 'leather-booties.jpg', 15, 0, 'Navy');

-- add shopping cart items
INSERT INTO shopping_cart (user_id, product_id, quantity)
VALUES
    (3, 8, 1),
    (3, 10, 1);