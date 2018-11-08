# Non - Functional Requirements
===========
A non-functional requirement (NFR) is a requirement that specifies criteria that can be used to judge the operation of a system, rather than specific behaviors. 
They are contrasted with functional requirements that define specific behavior or functions. **Functional requirements** define what a system is *supposed to do* and **non-functional requirements** define how a system is *supposed to be*.




# Product Requirements
1. **Usability Requirements**
    a. Provide Value Right Away - If you want new users to return to your app, you need to make sure that they discover the value early on, preferably during the onboarding process. If you don’t convince users to stay within the first week, you’re likely going to lose them forever. Millions of apps saturate the market, all of them competing for user attention, so it’s critical to make sure you offer immediate value. 
    b. Simple Navigation - When a user first downloads your app, they need to clearly understand how to navigate to complete their goal.This means that your navigation should have as few barriers as possible.The navigation should be comprehensible for the user so they won’t end up lost on a random page.
    c.
		
1. **Accessibility Requirements** : The extent to which the software system can be used by people with the widest range of capabilities to achieve a specified goal in a specified context of use.
    a. The system shall be accessible to people with disabilities in accordance with the Americans with Disabilities Act of 1990.
    b. The system shall be accessible by people with specific vision needs, to the extent that a user shall be able to:
        - Display the whole user interface in a large font without truncating displayed text or other values.
        - Use a screen magnifier to magnify a selected part of the screen.
        - Use a screen reader to read aloud information displayed.
        (An estimated 27% of working age adults has a vision difficulty or impairment.)

1. **Security Requirements**
    a. HTTP is strongly not recommended. Since iOS 9.0 App Transport Security (ATS) is enabled by default, so you have to use HTTPS instead of not encrypted HTTP. Unfortunately ATS can be easily disabled. That's fine if the app is during development and your server doesn't offer SSL yet, but an App Store build should never call HTTP requests and ATS should be enabled.
    b. According to NowSecure 80% of 201 of the most downloaded free iOS apps did opt out of ATS in December 2016.

1. **Dependability Requirements**
    a. Mobile applications need to operate successfully (or degrade gracefully) within a wide spectrum of operating conditions, such as a range of supported screen resolutions and form factors, network bandwidth situations and network types (2G, 3G, 4G, WiFi) etc.
    b. Mobile applications sometimes need to interact with the device’s sensors such as GPS, accelerometer, the ambient light sensor, camera etc. The application must respect the sensor’s operating characteristics such as its operating range, sensitivity, accuracy, minimum polling interval etc.
    c. Users expect a different quality of user experience from an application running on the mobile device than they do from their desktop computer. For example, it is much less acceptable to have to reboot the phone when a mobile application hangs.
  
1. **Performance Requirements**
    a. Modified data in a database should be updated for all users accessing it within 2 seconds
    b. The system shall respond to user commands within 500 milliseconds. 
		c. The system shall be available during 99.98% of business hours.


1. **Space Requirements**



# Organizational Requirements
1. **Environmental Requirements**

1. **Operational Requirements**

1. **Development Requirements**



# External Requirements=
1. **Regulatory Requirements**

1. **Ethical Requirements**

1. **Accounting Requirements**

1. **Safety/Security Requirements**
