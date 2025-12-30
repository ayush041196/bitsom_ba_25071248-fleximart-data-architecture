mongodb_operations.js
/****************************************************
 * MongoDB Operations for FlexiMart Product Catalog
 * Requirements: products_catalog.json must exist
 ****************************************************/


/***********************
 * Operation 1: Load Data
 * Import JSON file into 'products' collection
 * Command to run in terminal (not JavaScript):
 * mongoimport --db fleximart --collection products --file products_catalog.json --jsonArray
 ***********************/


/***********************
 * Operation 2: Basic Query
 * Find electronics under ₹50,000 and return name, price, stock
 ***********************/
db.products.find(
  { 
    category: "Electronics",
    price: { $lt: 50000 }
  },
  { 
    _id: 0,
    name: 1,
    price: 1,
    stock: 1
  }
);


/***********************
 * Operation 3: Review Analysis
 * Products with average rating >= 4.0
 * Using aggregation pipeline 
 ***********************/
db.products.aggregate([
  { $unwind: "$reviews" },
  {
    $group: {
      _id: "$product_id",
      name: { $first: "$name" },
      category: { $first: "$category" },
      avg_rating: { $avg: "$reviews.rating" }
    }
  },
  { 
    $match: { avg_rating: { $gte: 4.0 } }
  },
  {
    $project: {
      _id: 0,
      product_id: "$_id",
      name: 1,
      category: 1,
      avg_rating: 1
    }
  }
]);


/***********************
 * Operation 4: Update Operation
 * Add a new review to specific product: ELEC001
 ***********************/
db.products.updateOne(
  { product_id: "ELEC001" },
  {
    $push: {
      reviews: {
        user: "U999",
        rating: 4,
        comment: "Good value",
        date: new Date()
      }
    }
  }
);


/***********************
 * Operation 5: Complex Aggregation
 * Average price by category with product count
 * Sorted by highest avg_price
 ***********************/
db.products.aggregate([
  {
    $group: {
      _id: "$category",
      avg_price: { $avg: "$price" },
      product_count: { $sum: 1 }
    }
  },
  {
    $project: {
      _id: 0,
      category: "$_id",
      avg_price: 1,
      product_count: 1
    }
  },
  { $sort: { avg_price: -1 } }
]);
