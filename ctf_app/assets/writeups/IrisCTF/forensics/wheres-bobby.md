---
title: "Where's Bobby"
date: "2025-01-12"
ctf: "IrisCTF 2025"
category: "forensics"
difficulty: "Medium"
points: 247
tags: ["forensics", "osint", "geography"]
author: "Tham Le"
solved: true
---

# Where's Bobby (247 Points) - SOLVED

**Category**: Medium
**Type**: OSINT/Geography

## Challenge Description

Find the route number of a road based on an image taken during a road trip. The route has a body of water nearby and few populated areas.

## Solution

### Step 1: Initial Image Analysis

The image provides several key identifiers:

- Highway/expressway with modern construction
- Retaining wall on the left side
- Mountains visible in the background
- Green electronic traffic sign with Chinese characters
- Two-lane road with clear lane markings
- Limited development in the surrounding area

### Step 2: Sign Translation

1. Used Google Lens to read the Chinese text on the green sign:
   ```
   西沙屯桥至楼自庄桥 行驶畅通
   ```
2. Translation:
   - "From Xishatun Bridge to Louzizhuang Bridge"
   - "Smooth driving" (traffic status)

### Step 3: Location Search

1. Used Google Maps to search for the bridges mentioned
2. Located both bridges in China:
   - Xishatun Bridge (西沙屯桥)
   - Louzizhuang Bridge (楼自庄桥)
3. Metadata analysis revealed UTC+8 timezone, confirming China location

### Step 4: Route Verification

1. Used Google Earth to compare:
   - Bridge architecture matches image
   - Mountain profile aligns with background
   - Road characteristics (retaining wall, guardrails) match
2. Confirmed route as G234 in China
3. Additional verification:
   - Presence of water body along route as mentioned in challenge
   - Sparse population in area matches description

### Step 5: Flag Construction

- Route number: 234
- Country code: CN
- Flag format: `irisctf{234_CN}`

## Tools Used

- Google Lens (sign translation)
- Google Maps (location search)
- Google Earth (terrain verification)
- Image metadata analysis (timezone confirmation)

## Key Insights

1. Chinese characters on sign provided crucial starting point
2. Bridge names were unique identifiers for location
3. UTC+8 timezone metadata helped confirm correct country
4. Mountain profile and road construction style matched G234 characteristics
5. Challenge hint about water body helped verify correct route

## References

- Google Maps location of bridges
- G234 route information
- Chinese highway numbering system
