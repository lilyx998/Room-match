Original App Design Project - README
===

# Room-match

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Room-match (like a Tinder but for finding roommates) auto-suggests people with similar price upper bounds, in similar locations, and uses map APIs to find apartments and filter by prices, etc.. Each user can create a profile, where they input their price range, location (maybe like 1 mile radius from [address] if feasible? or just city), their living styles, age, college/adult, pets, integrate their social media profiles, etc.. Users can "swipe right" on the auto-suggested list of people, and start to message each other. The app also includes a map feature, where people can search for apartment places and filter by price, size, etc.. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Matching/social
- **Mobile:**  Utilizes maps and locations 
- **Story:** Moving to a new city is hard, and obtaining a single bedroom apartment for a good price in a city can be very difficult. This app allows users to match to people with similar constraints, and learn more about and talk to their matches until they find perfect roommate match! 
- **Market:** For anyone looking for a roommate, especially those moving to a new place who do not know anyone. 
- **Habit:** Not a very addictive app; only used for need. 
- **Scope:** 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Login/logout
* Signup
* Create/edit profile 
* Your app uses at least one gesture (e.g. double tap to like, e.g. pinch to scale) 
* Your app incorporates at least one external library to add visual polish
* Your app uses at least one animation (e.g. fade in/out, e.g. animating a view growing and shrinking)
* Matching algo 
* Map API to find places, filter by price/location
* link to their instas (can dm there if i don't implement chat box)


**Optional Nice-to-have Stories**

* chat box

### 2. Screen Archetypes

* Home
   * Login/signup
* Profile view
   * Edit profile
   * required: name, price range, location, social media, age, pets, picture(s)
       * college [yes/no]
           * if yes, select your's from a list of colleges
           * if yes, optional put ur graduation year? 
       * if in college, do you only want to room with others from your college? 
   * optional: list more traits, or a bio
* Chat view (optional story)
    * ...
* Swipe view (like Tinder)
    * shows pictures, name, age, price range, location
    * can swipe right or left
        * maybe just tap a x or [check] button
    * once you swipe, they won't show up again?

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile
* Chat
* Swipe

**Flow Navigation** (Screen to Screen)

* Home
   * Profile
* Tab bar at bottom at screen

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

tab bar on bottom 

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
