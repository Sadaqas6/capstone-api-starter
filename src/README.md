# Little Attire

A luxury baby clothing e-commerce REST API, built as a solo capstone project for Year Up United's Software Development track. Little Attire extends an existing Spring Boot + MySQL e-commerce starter project, with the backend fully rebuilt and customized for a baby clothing storefront.

## About the Project

Little Attire allows customers to browse curated luxury baby clothing by category (Onesies & Bodysuits, Outerwear & Sets, Footwear & Accessories), filter by price and color, add items to a persistent shopping cart, manage their profile, and check out to place an order. Admin users can manage the product and category catalog.

This project started from a partially-implemented Spring Boot starter codebase containing two intentional bugs and several unimplemented features. All backend work below was completed from scratch or debugged and fixed:

### Bugs Fixed
- **Search bug** — `GET /products` was silently filtering out every non-featured product due to a leftover `.filter(Product::isFeatured)` line unrelated to the actual search parameters. Removed the erroneous filter so all matching products now return correctly.
- **Stock update bug** — `PUT /products/{id}` returned 200 OK but silently failed to persist stock changes, because `ProductService.update()` never copied the incoming `stock` value onto the entity before saving. Added the missing `setStock()` call.

### Features Implemented
- **Categories** (`CategoriesController` / `CategoryService`) — full CRUD, with create/update/delete restricted to admin users.
- **Shopping Cart** (`ShoppingCartController` / `ShoppingCartService`) — view cart, add product (increments quantity if already present), update quantity, and clear cart. Cart persists across logins.
- **Profile** (`ProfileController` / `ProfileService`) — view and update the logged-in user's profile.
- **Checkout** (`OrderController` / `OrderService` / `Order` / `OrderLineItem`) — converts the current user's shopping cart into an order with line items, pulling shipping address from the user's profile, then clears the cart.

### Tech Stack
- Java 17, Spring Boot, Spring Security (JWT authentication, role-based authorization)
- MySQL, Spring Data JPA / Hibernate
- Vanilla JS frontend (Mustache templates, Axios, Bootstrap)
- Insomnia for endpoint testing

## Database

The `database/` folder contains the database script (`little_attire.sql`). Run it in MySQL Workbench to create the `littleattire` schema with all tables and seed data (3 demo users — `user`, `admin`, `george`, all password `password`).

Update `src/main/resources/application.properties` to point at the `littleattire` database before running the application.

## Running the Project

1. Run the database script in MySQL Workbench.
2. Update `application.properties` with your MySQL credentials.
3. Run `ECommerceApplication.java` from IntelliJ (or `mvn spring-boot:run`).
4. The API runs on `http://localhost:8080`.
5. Open the frontend `index.html` to browse the store, or use Insomnia to test endpoints directly.

## Screenshots


![Home page](screenshots/home.png)
![Cart page](screenshots/cart.png)
![Profile page](screenshots/profile.png)
![Insomnia example](screenshots/insomnia-example.png)

## Interesting Code: Building the Shopping Cart from the Database

The starter frontend only had a login modal — there was no way for a new user to actually register through the UI, even though the backend already had a working `POST /register` endpoint. I added a full registration flow without needing to touch the backend at all, by reusing the existing modal pattern.

`application.js` adds a function to open a second modal, alongside the existing login one:

```javascript
function showRegisterForm()
{
    templateBuilder.build('register-form', {}, 'login');
}
 
function register()
{
    const username = document.getElementById("register-username").value;
    const password = document.getElementById("register-password").value;
    const confirm = document.getElementById("register-confirm").value;
 
    userService.register(username, password, confirm);
    hideModalForm();
}
```

The login and register modals now link to each other ("Create an account" / "Already have an account?"), and `UserService.register()` was updated so that a successful registration shows a confirmation message and automatically reopens the login modal, instead of just logging the response to the console:

```javascript
axios.post(url, register)
     .then(response => {
         const data = {
             message: "Account created! You can now log in."
         };
 
         templateBuilder.append("message", data, "errors")
         showLoginForm();
     })
```

What made this interesting to build was realizing the backend was already fully capable of handling registration — `POST /register` worked from day one in Insomnia — but nobody could reach it from the actual website. The fix wasn't new backend logic at all; it was noticing a gap between what the API could do and what the UI exposed, then closing that gap by following the same modal-building pattern the login form already used
## Future Versions

Features considered for future iterations, in rough priority order:

1. **Order history** — let customers view past orders (`GET /orders`).
2. **Product reviews/ratings** — allow customers to leave reviews on purchased products.
3. **Wishlist** — separate from the cart, a saved-for-later list.
4. **Admin dashboard UI** — a dedicated frontend view for managing products/categories instead of requiring Insomnia/API calls.

