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
Roommate Tinder auto-suggests people with similar price upper bounds, in similar locations, and uses map APIs to find apartments and filter by prices, etc.. Each user can create a profile, where they input their price range, location (maybe like 1 mile radius from [address] if feasible? or just city), their living styles, age, college/adult, pets, integrate their social media profiles, etc.. Users can "swipe right" on the auto-suggested list of people, and start to message each other. 

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
* Chat box 
* User can delete their own account
* Overlapping location radius rather than city for matching
* Auto-complete college and addresses
* College students can choose to only room with others from their college
* email verification to avoid spam account creation


### 2. Screen Archetypes

* Home
   * Login/signup
* Profile view
   * Edit profile
   * required: name, price range, location, social media, age, pets, picture(s)
       * college [yes/no]
           * if yes, select your's from a list of colleges
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

## Digital Wireframes
https://docs.google.com/presentation/d/1VT94967F8w928KYB4YxHWbRJeYeYF1Wx9abmrHMz2Sc/edit?usp=sharing

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
