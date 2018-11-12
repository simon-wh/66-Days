Non - Functional Requirements
===========
A non-functional requirement (NFR) is a requirement that specifies criteria that can be used to judge the operation of a system, rather than specific behaviors. 
They are contrasted with functional requirements that define specific behavior or functions. **Functional requirements** define what a system is **supposed to do** and **non-functional requirements** define how a system is **supposed to be**.


 # Product Requirements:-
 
 
 # Usability Requirements
1. **Simple Design** - The product shall be self‐explanatory and intuitive such that a user shall be able to use the app within 10 minutes of encountering the product for the first time.

1. **Provide Value Right Away** - If you want new users to return to your app, you need to make sure that they discover the value early on, preferably during the onboarding process. If you don’t convince users to stay within the first week, you’re likely going to lose them forever. Millions of apps saturate the market, all of them competing for user attention, so it’s critical to make sure you offer immediate value. 
   
1. **Simple Navigation** - When a user first downloads your app, they need to clearly understand how to navigate to complete their goal.This means that your navigation should have as few barriers as possible.The navigation should be comprehensible for the user so they won’t end up lost on a random page.
    
1. **Declutter** - Including too much information in your mobile app will undoubtedly result in frustrated users digging to find specific content. Make it as easy as possible for the user to consume your content with as little pinching and zooming as possible by presenting the information in a clear and concise way.

1. **Great Aesthetics** - Don’t overlook aesthetics. People often start with a template, and you can tell by the look and feel. You should think through the aesthetics, as well as speed and interaction, so you can engage users on a deeper level. 

1. **Platform Usability** - The **focus should be on building the IOS version** of the app. Also **might** give a hand at **Android after being done with IOS**.
		
#  Accessibility Requirements : 

The extent to which the software system can be used by people with the widest range of capabilities to achieve a specified goal in a specified context of use.
	
1. The system shall be accessible to people with disabilities in accordance with the **Disabilities Act of 1990**.
1. The system shall be accessible by people with **specific vision needs**, to the extent that a user shall be able to:
	
	- Display the whole user interface in a large font without truncating displayed text or other values.
        - Use a **screen magnifier** to magnify a selected part of the screen.
        - Use a **screen reader** to read aloud information displayed.
        (An estimated 27% of working age adults has a vision difficulty or impairment.)


# Security Requirements

1. HTTP is strongly not recommended. Since iOS 9.0 App Transport Security (ATS) is enabled by default, so you have to **use HTTPS instead of not encrypted HTTP**. Unfortunately ATS can be easily disabled. That's fine if the app is during development and your server doesn't offer SSL yet, but an App Store build should never call HTTP requests and ATS should be enabled.
According to NowSecure 80% of 201 of the most downloaded free iOS apps did opt out of ATS in December 2016.

1. **Login / Access levels**
1. **Password requirements** –   length, special characters, expiry, recycling policies, 2FA.
1. **Inactivity timeouts**   – durations, actions, traceability.
1. **Encryption** (data in flight   and at rest) – All external communications between the system’s data server and clients **may be encrypted**.

# Dependability Requirements
 
1. Mobile applications need to operate successfully (or degrade gracefully) within a **wide spectrum of operating conditions**, such as a range of supported screen resolutions and form factors, network bandwidth situations and network types (2G, 3G, 4G, WiFi) etc.
    
1. Mobile applications sometimes need to **interact with** the device’s **sensors such as GPS, accelerometer, the ambient light sensor, camera etc.** The application must respect the sensor’s operating characteristics such as its operating range, sensitivity, accuracy, minimum polling interval etc.
    
1. The IOS Mobile App should run on **iPhone 5s devices and later with iOS 11 onwards**.
   The Android Mobile App should run on **Android devices with Android 8 onwards**.
   
# Performance Requirements

1. Modified data in a **database should be updated for all users accessing it within 2 seconds**.

1. The system **restart cycle** must execute completely in **less than 60 seconds**.
    
1. The system shall respond to user commands within **500 milliseconds**. 
    
1. The system shall be available during **99.98% of business hours**.

