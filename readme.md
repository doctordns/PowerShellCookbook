# Managing Windows Server 2016 With PowerShell Cookbook

## Introduction

This repository contains an updated and revised library of scripts to accompany Thomas Lee's **_Managing Windows Server 2016 with PowerShell Cookbook_**.
[See Amazon for more details](https://www.amazon.co.uk/Windows-Server-Automation-PowerShell-Cookbook/dp/1787122042/ref=sr_1_cc_2?s=aps&ie=UTF8&qid=1506953050&sr=1-2-catcorr) of the book itself.

The book has 13 chapters and each chapter has a number of recipes.
Each recipe is planned to be included in this repository.
Read the book for more details on pre-requisites for each chapter.

The purpose of these scripts is two fold:
First, these scripts are a companion for the book.
Feel free to leverage the scripts - this repo makes it easier for you to avoid having to do a lot of retyping.
Also, the scripts demonstrate techniques you can use and approaches to follow when you develop scripts.
At the same time, there are some less than great practices which are employed to simplify the script.
For example, storing things in the root folder of a server is probably not a great idea, but it's simpler than using a huge long path'
If you use these scripts, please customise them for our own use.

## Index

- Chapter 1  - What's New in PowerShell and Windows Server 2013
- Chapter 2  - Implementing Nano Server
- Chapter 3  - Managing Windows Update
- Chapter 4  - Managing Printers
- Chapter 5  - Managing Windows Server Backup  
- Chapter 6  - Managing Performance
- Chapter 7  - Troubleshooting Windows
- Chapter 8  - Managing Windows Networking
- Chapter 9  - Managing Network Shares
- Chapter 10 - Managing Internet Information Server
- Chapter 11 - Managing Hyper-V
- Chapter 12 - Managing Azure  
- Chapter 13 - Using Desired State Configuration

Each chapter has a separate folder in this repository, and inside each chapter.
Additionally, there is a **Readme.MD** file that describes the recipes in the chapter along with the PowerShell scripts making up each recipe.

## Note

All recipes are 'as is' - if they work, that is great.
But if not, oh well. 
Please consider filing issues at GitHub if you do find errors or other issues.

Many of these scripts vary from what is published in the book.
There are a couple of reasons for this.
In the book, many of the scripts used the back tick character to create multi-line commands.
Turns out that didn't work very well - they are hard to read.
And in the process of finalising the book, some changes were made that broke the scripts.

With that in mind, I've tried to fix these where I have found an issue.
Additionally, the scripts have been reformatted to fit inside a 72-character line width.
To fit within that limit, I've made liberal use of hash tables and splatting.

## Feedback

Any comments: email Thomas Lee at DoctorDNS@Gmail.Com