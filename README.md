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

1. **admin_accounts**:
2. **admin_actions**:
3. **cart_items**:
4. **carts**:
5. **category_translations**:
6. **contact_messages**:
7. **discount_codes**:
8. **email_verifications**:
9. **feedback**:
10. **login_attempts**:
11. **loyalty_program**:
12. **metrics_events**:
13. **moderation_actions**:
14. **order_delivery_info**:
15. **order_items**:
16. **order_status_history**:
17. **order_timestamps**:
18. **orders**:
19. **password_resets**:
20. **product_categories**:
21. **product_comments**:
22. **product_images**:
23. **product_likes**:
24. **product_translations**:
25. **product_variants**:
26. **products**:
27. **translations**:
28. **user_2fa**:
29. **user_discounts**:
30. **user_loyalty_progress**:
31. **user_permissions**:
32. **user_sessions**:
33. **users**:

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
