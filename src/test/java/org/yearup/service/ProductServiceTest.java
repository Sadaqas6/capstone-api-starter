package org.yearup.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.yearup.models.Product;
import org.yearup.repository.ProductRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ProductServiceTest
{
    private ProductRepository productRepository;
    private ProductService productService;

    @BeforeEach
    void setUp()
    {
        productRepository = mock(ProductRepository.class);
        productService = new ProductService(productRepository);
    }

    private Product buildProduct(int id, String name, double price, int categoryId,
                                 String subCategory, boolean featured)
    {
        Product product = new Product();
        product.setProductId(id);
        product.setName(name);
        product.setPrice(price);
        product.setCategoryId(categoryId);
        product.setDescription("Test description");
        product.setSubCategory(subCategory);
        product.setFeatured(featured);
        product.setImageUrl("test.jpg");
        product.setStock(10);
        return product;
    }

    // ---------- Bug 1: search should not silently drop non-featured products ----------

    @Test
    void search_withNoParams_returnsNonFeaturedProductsToo()
    {
        Product featured = buildProduct(1, "Featured Onesie", 39.99, 1, "Ivory", true);
        Product notFeatured = buildProduct(2, "Plain Onesie", 19.99, 1, "White", false);

        when(productRepository.findAll()).thenReturn(List.of(featured, notFeatured));

        List<Product> results = productService.search(null, null, null, null);

        assertEquals(2, results.size(),
                "search() with no filters should return ALL products, including non-featured ones");
        assertTrue(results.contains(notFeatured),
                "Non-featured products must not be silently excluded from search results");
    }

    @Test
    void search_byCategoryOnly_returnsAllMatchingRegardlessOfFeatured()
    {
        Product featured = buildProduct(1, "Featured Bodysuit", 64.99, 1, "Blush", true);
        Product notFeatured = buildProduct(2, "Plain Bodysuit", 44.99, 1, "Sage", false);

        when(productRepository.findByCategoryId(1)).thenReturn(List.of(featured, notFeatured));

        List<Product> results = productService.search(1, null, null, null);

        assertEquals(2, results.size());
    }

    @Test
    void search_byMinAndMaxPrice_filtersCorrectly()
    {
        Product cheap = buildProduct(1, "Cheap Item", 10.00, 1, "White", false);
        Product midRange = buildProduct(2, "Mid Item", 50.00, 1, "White", false);
        Product expensive = buildProduct(3, "Expensive Item", 150.00, 1, "White", false);

        when(productRepository.findAll()).thenReturn(List.of(cheap, midRange, expensive));

        List<Product> results = productService.search(null, 25.0, 100.0, null);

        assertEquals(1, results.size());
        assertEquals("Mid Item", results.get(0).getName());
    }

    @Test
    void search_bySubCategory_isCaseInsensitive()
    {
        Product blush = buildProduct(1, "Blush Item", 30.00, 1, "Blush", false);
        Product sage = buildProduct(2, "Sage Item", 30.00, 1, "Sage", false);

        when(productRepository.findAll()).thenReturn(List.of(blush, sage));

        List<Product> results = productService.search(null, null, null, "blush");

        assertEquals(1, results.size());
        assertEquals("Blush Item", results.get(0).getName());
    }

    // ---------- Bug 2: update() must persist stock changes ----------

    @Test
    void update_changesStock_andPersistsIt()
    {
        Product existing = buildProduct(1, "Organic Onesie", 39.99, 1, "Ivory", true);
        existing.setStock(10);

        Product incoming = buildProduct(1, "Organic Onesie", 39.99, 1, "Ivory", true);
        incoming.setStock(50);

        when(productRepository.findById(1)).thenReturn(Optional.of(existing));
        when(productRepository.save(any(Product.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Product result = productService.update(1, incoming);

        assertEquals(50, result.getStock(),
                "update() must copy the incoming stock value onto the saved entity");
    }

    @Test
    void update_changesPriceAndDescription_alongsideStock()
    {
        Product existing = buildProduct(1, "Cardigan", 99.99, 2, "Cream", false);
        existing.setStock(20);

        Product incoming = buildProduct(1, "Cardigan", 109.99, 2, "Cream", false);
        incoming.setDescription("Updated description");
        incoming.setStock(5);

        when(productRepository.findById(1)).thenReturn(Optional.of(existing));
        when(productRepository.save(any(Product.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Product result = productService.update(1, incoming);

        assertEquals(109.99, result.getPrice());
        assertEquals("Updated description", result.getDescription());
        assertEquals(5, result.getStock());
    }

    @Test
    void update_savesEntityExactlyOnce()
    {
        Product existing = buildProduct(1, "Booties", 59.99, 3, "Tan", false);
        Product incoming = buildProduct(1, "Booties", 59.99, 3, "Tan", false);
        incoming.setStock(99);

        when(productRepository.findById(1)).thenReturn(Optional.of(existing));
        when(productRepository.save(any(Product.class))).thenAnswer(invocation -> invocation.getArgument(0));

        productService.update(1, incoming);

        verify(productRepository, times(1)).save(any(Product.class));
    }
}