# README

Follow the rabbit.


1. Subscribe to actioncable.
    - Localhost: ws://localhost:3000/cable
    - Production: ws://qua-assessment.herokuapp.com/cable

    After that you should see a welcome message `{"type":"welcome"}` and a stream of regular ping messages: `{"type":"ping","message":1615807950}`.

2. Subscribe to SampleChannel.
    To start getting messages from `SampleChannel` you need to create a simple subscription request:
    ```
    {
      "command":"subscribe",
      "identifier":"{\"channel\":\"SampleChannel\"}"
    }
    ```
    In response you must get a confirmation, which should look like: 
    ```
    {
      "identifier":"{
        \"channel\":\"SampleChannel\"
      }",
      "type":"confirm_subscription"
    }
    ```
    After that, every 5 seconds, you will receive the actual users count.
    ```
    {
      "identifier":"{
      \"channel\":\"SampleChannel\"
      }",
      "message":{
        "title":"users_online","message":1
      }
    }
    ```

3. Do what you must...I will watch you.


<p align="center">
<img width="300" height="500" src="https://static.wikia.nocookie.net/elderscrolls/images/b/ba/Imperial_Prison_Guard.png/revision/latest?cb=20131214131751">
</p>