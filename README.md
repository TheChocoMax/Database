# PostgreSQL Database Generation

This repository contains SQL scripts to generate a database schema in Postgre.
The schema includes tables for managing users, articles, carts, orders, and more.

## Getting Started

To set up the database locally, you'll need Docker installed. Follow the steps below to build and run the database in a container.

### Setup Steps

1. **Build the Docker Image**:

   ```bash
   docker build -t chocomax-database-image .
   ```

2. **Run the Docker Container**:

   ```bash
   docker run -d -p 5432:5432 --name chocomax-database-container -e POSTGRES_PASSWORD=myrootpassword chocomax-database-image
   ```

3. **Access the Database**:

   ```bash
   docker exec -it chocomax-database-container psql -h /run/postgresql -U postgres -d chocomax
   ```

## Database Schema Overview

The database schema consists of the following tables:

1. **admin_accounts**: Stores admin-level user accounts with roles like superadmin, admin, or moderator.
2. **admin_actions**: Logs actions taken by admin users for auditing purposes.
3. **cart_items**: Represents the product variants added to a cart with their quantities.
4. **carts**: Tracks user carts, including anonymous sessions.
5. **category_translations**: Contains translated names and descriptions for product categories.
6. **contact_messages**: Stores messages sent through the contact form by users or visitors.
7. **discount_codes**: Defines promotional discount codes with rules and usage limits.
8. **email_verifications**: Manages email verification tokens and statuses for user accounts.
9. **feedback**: Allows users to rate and comment on products they've purchased.
10. **login_attempts**: Records login attempts with metadata like IP, user agent, and success flag.
11. **loyalty_program**: Defines promotions such as "buy X get Y" for specific products.
12. **metrics_events**: Stores anonymous event logs for analytics purposes.
13. **moderation_actions**: Logs actions taken to moderate users, products, or comments.
14. **order_delivery_info**: Stores delivery-related information such as address and delivery agent.
15. **order_items**: Contains product variant items included in each order.
16. **order_status_history**: Tracks the status changes of orders over time.
17. **order_timestamps**: Keeps timestamps for different stages in the order lifecycle.
18. **orders**: Main order records with price, status, and delivery type.
19. **password_resets**: Stores reset tokens for users to change their passwords securely.
20. **product_categories**: Defines categories to group products (e.g., Chocolate, Gifts).
21. **product_comments**: Stores user comments on products, optionally moderated.
22. **product_images**: Manages images associated with products and their variants.
23. **product_likes**: Tracks which users have liked which products.
24. **product_translations**: Contains translated product names and descriptions.
25. **product_variants**: Defines variations of a product (e.g., size or test versions).
26. **products**: Stores product information like name, description, price, and status.
27. **translations**: Generic key-value storage for UI translation strings across languages.
28. **user_2fa**: Manages users' two-factor authentication settings and secrets.
29. **user_discounts**: Tracks which discount codes a user has used.
30. **user_loyalty_progress**: Tracks individual users’ progress in loyalty programs.
31. **user_permissions**: Defines granular access permissions granted to users.
32. **user_sessions**: Stores active session tokens and metadata for logged-in users.
33. **users**: Main user table with account credentials and personal information.

The tables can be listed with the following command:

```sql
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
```

## Usage

1. **Clone the Repository**: Clone this repository to your local machine using `git clone`.

2. **Execute SQL Scripts**: Run the provided SQL scripts in your Postgre environment to create the database schema.

3. **Customization**: Modify the schema or add additional features as per your requirements.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
