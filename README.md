# 36 Questions

This takes the questions from the "The Experimental Generation of Interpersonal Closeness"[^1] paper
and makes them available in a handy web app. Ideally this will be available offline as a PWA.
  
[^1]: Aron A, Melinat E, Aron EN, Vallone RD, Bator RJ. The Experimental Generation of Interpersonal Closeness: A Procedure and Some Preliminary Findings. Personality and Social Psychology Bulletin. 1997;23(4):363-377. [doi:10.1177/0146167297234003](https://doi.org/10.1177/0146167297234003)
  
## Build

```
elm make --output=public/questions.js src/Main.elm
```

## Dev Server

Requires that you have python 3 installed.

```
python3 -m http.server
```
