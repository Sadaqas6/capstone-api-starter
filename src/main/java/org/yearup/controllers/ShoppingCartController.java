package org.yearup.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.yearup.models.ShoppingCart;
import org.yearup.models.ShoppingCartItem;
import org.yearup.models.User;
import org.yearup.security.jwt.ResourceNotFoundException;
import org.yearup.service.ShoppingCartService;
import org.yearup.service.UserService;

import java.security.Principal;


@RestController
@RequestMapping("cart")
@CrossOrigin(origins = "http://localhost:63342")
@PreAuthorize("isAuthenticated()")

public class ShoppingCartController
{

    private final ShoppingCartService shoppingCartService;
    private final UserService userService;

    public ShoppingCartController(ShoppingCartService shoppingCartService, UserService userService) {
        this.shoppingCartService = shoppingCartService;
        this.userService = userService;
    }


    public int getCurrentUserId(Principal principal) {
    String userName = principal.getName();

    User user = userService.getByUserName(userName);


        if (user == null) {
            throw new ResourceNotFoundException("User not found");
        }

        return user.getId();
}



    @GetMapping
    public ResponseEntity<ShoppingCart> getCart(Principal principal) {

        int userId = getCurrentUserId(principal);

        ShoppingCart cart = shoppingCartService.getByUserId(userId);

        return ResponseEntity.ok(cart); // 200
    }


    @PostMapping("products/{productId}")
    public ResponseEntity<ShoppingCart> addProduct(Principal principal, @PathVariable int productId){

        int userId = getCurrentUserId(principal);
        ShoppingCart cart = shoppingCartService.addProduct(userId, productId);

        return ResponseEntity.status(HttpStatus.CREATED).body(cart); // 201
    }


    @PutMapping("products/{productId}")
    public ResponseEntity<ShoppingCart> updateProduct(
            Principal principal,
            @PathVariable int productId,
            @RequestBody ShoppingCartItem item) {

        int userId = getCurrentUserId(principal);

        ShoppingCart cart = shoppingCartService
                .updateProductQuantity(userId, productId, item.getQuantity());

        return ResponseEntity.ok(cart); // 200 OK
    }

    @DeleteMapping
    public ResponseEntity<Void> clearCart(Principal principal) {

        int userId = getCurrentUserId(principal);

        shoppingCartService.clearCart(userId);

        return ResponseEntity.noContent().build(); // 204
    }


    @DeleteMapping("/products/{productId}")
    public ResponseEntity<ShoppingCart> decreaseItem(
            @PathVariable int productId,
            Principal principal) {

        int userId = getCurrentUserId(principal);

        ShoppingCart cart = shoppingCartService.decreaseItem(productId, userId);

        return ResponseEntity.ok(cart);
    }


}
