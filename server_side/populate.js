const mongoose = require('mongoose');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

// Import models
const Category = require('./model/category');
const SubCategory = require('./model/subCategory');
const Brand = require('./model/brand');
const VariantType = require('./model/variantType');
const Variant = require('./model/variant');
const Product = require('./model/product');
const Coupon = require('./model/couponCode');
const Poster = require('./model/poster');
const User = require('./model/user');
const Order = require('./model/order');

// Use your machine IP for mobile access
const SERVER_IP = '10.161.175.199'; // Replace with your actual IP
const BASE_URL = `http://${SERVER_IP}:3000`;

// MongoDB connection
mongoose.connect(process.env.MONGO_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true
});

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', async () => {
    console.log('Connected to MongoDB');
    await populateDatabase();
});

async function clearDatabase() {
    console.log('Clearing existing data...');
    await Category.deleteMany({});
    await SubCategory.deleteMany({});
    await Brand.deleteMany({});
    await VariantType.deleteMany({});
    await Variant.deleteMany({});
    await Product.deleteMany({});
    await Coupon.deleteMany({});
    await Poster.deleteMany({});
    await User.deleteMany({});
    await Order.deleteMany({});
    console.log('Database cleared');
}

async function populateDatabase() {
    try {
        await clearDatabase();

        console.log('Starting database population...');
        console.log('Using base URL:', BASE_URL);

        // 1. Create Users
        console.log('Creating users...');
        const user = await User.create({
            name: 'admin',
            password: 'admin123'
        });
        console.log('User created:', user.name);

        // 2. Create Categories
        console.log('Creating categories...');
        const categories = await Category.create([
            {
                name: 'Electronics',
                image: `${BASE_URL}/image/category/1715896709207_620.png`
            },
            {
                name: 'Fashion',
                image: `${BASE_URL}/image/category/1715897631528_365.png`
            },
            {
                name: 'Home & Kitchen',
                image: `${BASE_URL}/image/category/1715897681715_896.png`
            },
            {
                name: 'Books',
                image: `${BASE_URL}/image/category/1715901354314_503.png`
            },
            {
                name: 'Sports',
                image: `${BASE_URL}/image/category/1715977900679_895.png`
            },
            {
                name: 'Beauty',
                image: `${BASE_URL}/image/category/1715977910237_858.png`
            }
        ]);
        console.log('Categories created:', categories.length);

        // 3. Create SubCategories
        console.log('Creating subcategories...');
        const subCategories = await SubCategory.create([
            { name: 'Smartphones', categoryId: categories[0]._id },
            { name: 'Laptops', categoryId: categories[0]._id },
            { name: 'Wearables', categoryId: categories[0]._id },
            { name: 'Men Clothing', categoryId: categories[1]._id },
            { name: 'Women Clothing', categoryId: categories[1]._id },
            { name: 'Home Decor', categoryId: categories[2]._id },
            { name: 'Kitchen Appliances', categoryId: categories[2]._id },
            { name: 'Fiction', categoryId: categories[3]._id },
            { name: 'Non-Fiction', categoryId: categories[3]._id },
            { name: 'Fitness', categoryId: categories[4]._id },
            { name: 'Outdoor', categoryId: categories[4]._id },
            { name: 'Skincare', categoryId: categories[5]._id },
            { name: 'Makeup', categoryId: categories[5]._id }
        ]);
        console.log('Subcategories created:', subCategories.length);

        // 4. Create Brands
        console.log('Creating brands...');
        const brands = await Brand.create([
            { name: 'Samsung', subcategoryId: subCategories[0]._id },
            { name: 'Apple', subcategoryId: subCategories[0]._id },
            { name: 'Google', subcategoryId: subCategories[0]._id },
            { name: 'Dell', subcategoryId: subCategories[1]._id },
            { name: 'HP', subcategoryId: subCategories[1]._id },
            { name: 'Nike', subcategoryId: subCategories[4]._id },
            { name: 'Adidas', subcategoryId: subCategories[4]._id },
            { name: 'IKEA', subcategoryId: subCategories[5]._id },
            { name: 'Maybelline', subcategoryId: subCategories[12]._id },
            { name: "L'Oreal", subcategoryId: subCategories[12]._id }
        ]);
        console.log('Brands created:', brands.length);

        // 5. Create Variant Types
        console.log('Creating variant types...');
        const variantTypes = await VariantType.create([
            { name: 'Color', type: 'color' },
            { name: 'Size', type: 'size' },
            { name: 'Storage', type: 'storage' },
            { name: 'RAM', type: 'memory' }
        ]);
        console.log('Variant types created:', variantTypes.length);

        // 6. Create Variants
        console.log('Creating variants...');
        const variants = await Variant.create([
            { name: 'Black', variantTypeId: variantTypes[0]._id },
            { name: 'White', variantTypeId: variantTypes[0]._id },
            { name: 'Blue', variantTypeId: variantTypes[0]._id },
            { name: 'Red', variantTypeId: variantTypes[0]._id },
            { name: 'S', variantTypeId: variantTypes[1]._id },
            { name: 'M', variantTypeId: variantTypes[1]._id },
            { name: 'L', variantTypeId: variantTypes[1]._id },
            { name: 'XL', variantTypeId: variantTypes[1]._id },
            { name: '64GB', variantTypeId: variantTypes[2]._id },
            { name: '128GB', variantTypeId: variantTypes[2]._id },
            { name: '256GB', variantTypeId: variantTypes[2]._id },
            { name: '512GB', variantTypeId: variantTypes[2]._id },
            { name: '8GB', variantTypeId: variantTypes[3]._id },
            { name: '16GB', variantTypeId: variantTypes[3]._id },
            { name: '32GB', variantTypeId: variantTypes[3]._id }
        ]);
        console.log('Variants created:', variants.length);

        // 7. Create Products
        console.log('Creating products...');
        const products = await Product.create([
            {
                name: 'Samsung Galaxy A53',
                description: 'Latest Samsung smartphone with amazing features',
                quantity: 50,
                price: 399.99,
                offerPrice: 349.99,
                proCategoryId: categories[0]._id,
                proSubCategoryId: subCategories[0]._id,
                proBrandId: brands[0]._id,
                proVariantTypeId: variantTypes[2]._id,
                proVariantId: [variants[8]._id.toString(), variants[9]._id.toString()],
                images: [
                    { image: 1, url: `${BASE_URL}/image/products/a53_1.png` },
                    { image: 2, url: `${BASE_URL}/image/products/a53_2.png` },
                    { image: 3, url: `${BASE_URL}/image/products/a53_3.png` }
                ]
            },
            {
                name: 'Apple Watch Series 7',
                description: 'Premium smartwatch with health monitoring',
                quantity: 30,
                price: 399.00,
                offerPrice: 379.00,
                proCategoryId: categories[0]._id,
                proSubCategoryId: subCategories[2]._id,
                proBrandId: brands[1]._id,
                proVariantTypeId: variantTypes[0]._id,
                proVariantId: [variants[0]._id.toString(), variants[1]._id.toString()],
                images: [
                    { image: 1, url: `${BASE_URL}/image/products/apple_watch_series_7_1.png` },
                    { image: 2, url: `${BASE_URL}/image/products/apple_watch_series_7_2.png` },
                    { image: 3, url: `${BASE_URL}/image/products/apple_watch_series_7_3.png` }
                ]
            },
            {
                name: 'Beats Studio 3',
                description: 'Wireless noise cancelling headphones',
                quantity: 25,
                price: 299.99,
                offerPrice: 249.99,
                proCategoryId: categories[0]._id,
                proSubCategoryId: subCategories[2]._id,
                proBrandId: brands[1]._id,
                proVariantTypeId: variantTypes[0]._id,
                proVariantId: [variants[0]._id.toString(), variants[2]._id.toString()],
                images: [
                    { image: 1, url: `${BASE_URL}/image/products/beats_studio_3-1.png` },
                    { image: 2, url: `${BASE_URL}/image/products/beats_studio_3-2.png` },
                    { image: 3, url: `${BASE_URL}/image/products/beats_studio_3-3.png` },
                    { image: 4, url: `${BASE_URL}/image/products/beats_studio_3-4.png` }
                ]
            },
            {
                name: 'Nike Air Force',
                description: 'Classic sneakers for everyday wear',
                quantity: 100,
                price: 120.00,
                offerPrice: 99.99,
                proCategoryId: categories[1]._id,
                proSubCategoryId: subCategories[4]._id,
                proBrandId: brands[5]._id,
                proVariantTypeId: variantTypes[1]._id,
                proVariantId: [variants[4]._id.toString(), variants[5]._id.toString(), variants[6]._id.toString()],
                images: [
                    { image: 1, url: `${BASE_URL}/image/products/nike_air_force.jpg` }
                ]
            },
            {
                name: 'MacBook Pro',
                description: 'Powerful laptop for professionals',
                quantity: 15,
                price: 1999.00,
                offerPrice: 1899.00,
                proCategoryId: categories[0]._id,
                proSubCategoryId: subCategories[1]._id,
                proBrandId: brands[1]._id,
                proVariantTypeId: variantTypes[3]._id,
                proVariantId: [variants[12]._id.toString(), variants[13]._id.toString()],
                images: [
                    { image: 1, url: `${BASE_URL}/image/products/macbook_pro.jpg` }
                ]
            }
        ]);
        console.log('Products created:', products.length);

        // 8. Create Coupons
        console.log('Creating coupons...');
        const coupons = await Coupon.create([
            {
                couponCode: 'WELCOME10',
                discountType: 'percentage',
                discountAmount: 10,
                minimumPurchaseAmount: 50,
                endDate: new Date('2024-12-31'),
                status: 'active',
                applicableCategory: categories[0]._id
            },
            {
                couponCode: 'SUMMER25',
                discountType: 'fixed',
                discountAmount: 25,
                minimumPurchaseAmount: 100,
                endDate: new Date('2024-08-31'),
                status: 'active'
            },
            {
                couponCode: 'FASHION15',
                discountType: 'percentage',
                discountAmount: 15,
                minimumPurchaseAmount: 75,
                endDate: new Date('2024-09-30'),
                status: 'active',
                applicableCategory: categories[1]._id
            }
        ]);
        console.log('Coupons created:', coupons.length);

        // 9. Create Posters
        console.log('Creating posters...');
        const posters = await Poster.create([
            {
                posterName: 'Summer Sale',
                imageUrl: `${BASE_URL}/image/poster/1715981970466_shopping.png`
            },
            {
                posterName: 'New Arrivals', 
                imageUrl: `${BASE_URL}/image/poster/1715981959736_beats_studio_3-1.png`
            },
            {
                posterName: 'Tech Week',
                imageUrl: `${BASE_URL}/image/poster/1715912282258_apple_watch_series_7_1.png`
            },
            {
                posterName: 'Fashion Festival',
                imageUrl: `${BASE_URL}/image/poster/1715912292911_a53_2.png`
            }
        ]);
        console.log('Posters created:', posters.length);

        // 10. Create Orders
        console.log('Creating orders...');
        const orders = await Order.create([
            {
                userID: user._id,
                orderStatus: 'delivered',
                items: [
                    {
                        productID: products[0]._id,
                        productName: products[0].name,
                        quantity: 1,
                        price: products[0].offerPrice,
                        variant: '128GB'
                    },
                    {
                        productID: products[3]._id,
                        productName: products[3].name,
                        quantity: 2,
                        price: products[3].offerPrice,
                        variant: 'M'
                    }
                ],
                totalPrice: products[0].offerPrice + (products[3].offerPrice * 2),
                shippingAddress: {
                    phone: '+1234567890',
                    street: '123 Main St',
                    city: 'New York',
                    state: 'NY',
                    postalCode: '10001',
                    country: 'USA'
                },
                paymentMethod: 'prepaid',
                couponCode: coupons[0]._id,
                orderTotal: {
                    subtotal: products[0].offerPrice + (products[3].offerPrice * 2),
                    discount: 34.99,
                    total: products[0].offerPrice + (products[3].offerPrice * 2) - 34.99
                },
                trackingUrl: 'https://tracking.example.com/123456'
            },
            {
                userID: user._id,
                orderStatus: 'processing',
                items: [
                    {
                        productID: products[1]._id,
                        productName: products[1].name,
                        quantity: 1,
                        price: products[1].offerPrice,
                        variant: 'Black'
                    }
                ],
                totalPrice: products[1].offerPrice,
                shippingAddress: {
                    phone: '+1987654321',
                    street: '456 Oak Ave',
                    city: 'Los Angeles',
                    state: 'CA',
                    postalCode: '90210',
                    country: 'USA'
                },
                paymentMethod: 'cod',
                orderTotal: {
                    subtotal: products[1].offerPrice,
                    discount: 0,
                    total: products[1].offerPrice
                }
            }
        ]);
        console.log('Orders created:', orders.length);

        console.log('✅ Database population completed successfully!');
        console.log('📊 Summary:');
        console.log(`   Users: 1`);
        console.log(`   Categories: ${categories.length}`);
        console.log(`   SubCategories: ${subCategories.length}`);
        console.log(`   Brands: ${brands.length}`);
        console.log(`   VariantTypes: ${variantTypes.length}`);
        console.log(`   Variants: ${variants.length}`);
        console.log(`   Products: ${products.length}`);
        console.log(`   Coupons: ${coupons.length}`);
        console.log(`   Posters: ${posters.length}`);
        console.log(`   Orders: ${orders.length}`);

        process.exit(0);
    } catch (error) {
        console.error('❌ Error populating database:', error);
        process.exit(1);
    }
}
