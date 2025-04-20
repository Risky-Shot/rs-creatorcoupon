# 🎫 RS Creator Coupon System
A modular coupon management system for RedM servers using `VORP Core` and `Feather Menu`. This allows admins to create, update, and manage coupons that provide players with in-game rewards like items, weapons, and money.

## 🧩 Dependencies
 - VORP Core
 - feather-menu
 - ox_mysql
 - vorp_inventory

Make sure all are properly installed and started before this script.

## 📝 Description
The rs-creatorcoupon system is a dynamic menu for managing in-game coupons. Coupons can reward players with items, weapons, and in-game currency (money, gold, rol). Each coupon can have a usage limit and activation status.

### ✨ Features
✅ Create Coupons
➤ Enter a unique code and define its usage limit.

✅ User Usage Limit
➤ Single user can only redeem the code once. (based on identifier)

✅ Manage Existing Coupons
➤ View and edit existing coupon codes, usage limit, and active status.

✅ Reward Management
  - 🧱 Items: Add, update, delete item rewards with specific quantities.
  - 🔫 Weapons: Add, update, delete weapon rewards (via hash string).
  - 💰 Money: Set money, gold, and rol values.

## 🚀 Getting Started
  1. Add this script to your RedM resources folder.
  2. Run `install/sql.sql` to your database.
  3. Add `ensure rs-creatorcoupon` to server.cfg
     
## 🧠 Future Ideas
  - Reward To Creator When his code is used.
  - Implement better code readability
    
<details>
  <summary>Showcase Images</summary>
  
  ### Home Page
  ![image](https://github.com/user-attachments/assets/efbfa838-41a6-4caf-8315-c06c83332a48)
  
  ### Create New Coupon Page
  ![{F0E004F9-9767-407C-9CC4-AA3765370E9E}](https://github.com/user-attachments/assets/a888f5bf-8fce-402f-b5cc-8fafe0cf75d7)
  
  ### Available Coupons Page
  ![{1BD9AF0B-8DF6-45DE-BBA9-5E07312B6FA8}](https://github.com/user-attachments/assets/7537b013-5a92-4cf9-b2e7-934e927e9972)
  
  ### Manage Coupon Page
  ![{BDB47E68-FA43-440D-B9F9-A24E05E4B8BB}](https://github.com/user-attachments/assets/3a387cea-518e-4f48-8c74-70f772d38d35)
  
  ### Manage Coupon Reward Items Page
  ![{12E9D320-989D-4FC6-A51A-8F9B4A892E02}](https://github.com/user-attachments/assets/4865b0ca-d2a9-4e35-a79a-ee19f9a71435)
  ![{DA8B15CE-7827-411A-B999-B5301AB145EB}](https://github.com/user-attachments/assets/43f4fea4-922c-4a78-a019-295f8f1fc949)
  
  ### Manage Coupon Reward Weapons Page
  ![{1EE90B82-558F-4F41-935D-CD40CEB9CA00}](https://github.com/user-attachments/assets/9753f86f-81cc-465b-bcc7-3d357e834e3b)
  
  ### Manage Coupon Reward Money Page
  ![{2FFF6FE5-B2ED-4B4A-8DF6-B61DEE3BE6C6}](https://github.com/user-attachments/assets/a27bfbb9-dcb9-4971-99bb-f79c12ac2ac7)
  
  ### Redeem Prompt
  ![{6063574B-2EBF-4700-8C3A-0C6C488F5243}](https://github.com/user-attachments/assets/6e083057-9f68-417c-a4d6-bc89fa4b4d52)
</details>
