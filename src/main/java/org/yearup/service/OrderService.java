package org.yearup.service;

import org.springframework.stereotype.Service;
import org.yearup.models.*;
import org.yearup.repository.OrderLineItemRepository;
import org.yearup.repository.OrderRepository;

import java.time.LocalDateTime;

@Service
public class OrderService
{
    private final OrderRepository orderRepository;
    private final OrderLineItemRepository orderLineItemRepository;
    private final ShoppingCartService shoppingCartService;
    private final ProfileService profileService;

    public OrderService(OrderRepository orderRepository,
                        OrderLineItemRepository orderLineItemRepository,
                        ShoppingCartService shoppingCartService,
                        ProfileService profileService)
    {
        this.orderRepository = orderRepository;
        this.orderLineItemRepository = orderLineItemRepository;
        this.shoppingCartService = shoppingCartService;
        this.profileService = profileService;
    }

    public Order createOrderFromCart(int userId)
    {
        ShoppingCart cart = shoppingCartService.getByUserId(userId);
        Profile profile = profileService.getByUserId(userId);

        Order order = new Order();
        order.setUserId(userId);
        order.setDate(LocalDateTime.now());

        if (profile != null)
        {
            order.setAddress(profile.getAddress());
            order.setCity(profile.getCity());
            order.setState(profile.getState());
            order.setZip(profile.getZip());
        }

        order.setShippingAmount(0);

        Order savedOrder = orderRepository.save(order);

        for (ShoppingCartItem item : cart.getItems().values())
        {
            OrderLineItem lineItem = new OrderLineItem();
            lineItem.setOrderId(savedOrder.getOrderId());
            lineItem.setProductId(item.getProductId());
            lineItem.setSalesPrice(item.getProduct().getPrice());
            lineItem.setQuantity(item.getQuantity());
            lineItem.setDiscount(item.getDiscountPercent());

            orderLineItemRepository.save(lineItem);
        }

        shoppingCartService.clearCart(userId);

        return savedOrder;
    }
}