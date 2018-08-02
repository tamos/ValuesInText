# Command Line

The command line (terminal in Mac/Linux, Powershell/cmd.exe in Windows) lets you access your file system directly. It saves a lot of time and can be much easier to use, but takes some time to get comfortable. Git is also much easier to use through the command line. 

Tutorials: 
	- https://classes.cs.uchicago.edu/archive/2017/fall/12100-1/labs/lab1_linux/index.html
	- https://www.learnenough.com/command-line-tutorial
	- https://lifehacker.com/5633909/who-needs-a-mouse-learn-to-use-the-command-line-for-almost-anything
	- https://www.bleepingcomputer.com/tutorials/windows-command-prompt-introduction/


# Git

The basic git workflow is to (i) create a branch; (ii) make changes to that branch; (iii) add those changed files, commit when ready; (iv) push the changed files to the server.

This looks like:

git branch (To see which branch you are currently using)

git checkout -b mybranchname (To make a new branch and move to it)

(do your work)

git add mychangedfiles

git commit -m"my commit message"

git push origin mybranchname


When you are happy with your changes and want to share them with everyone, you can make a request to merge into the master branch by creating a pull request on the Github website. You can also delete the branch from the website if you don't need it anymore.  

If you want to switch to another branch, you can do:

git checkout another_branch_name

When you are moving between branches (this is the best part of git), the files you make/modify will only be available on that branch. So if you break something or delete something on one branch, you can just switch back to the master, create a new branch, and your files will be available as a copy of the master. 


Tutorials:
	- https://git-scm.com/book/en/v1/Getting-Started
	- https://www.tutorialspoint.com/git/index.htm
	- https://classes.cs.uchicago.edu/archive/2017/fall/12100-1/labs/lab1_linux/index.html


# Web Scraping

Key Concepts:
	- html is a tree (https://en.wikipedia.org/wiki/Tree_(data_structure))
		<html> 
			<p>
				This is a paragraph.
			</p>
		</html> 

	A tag (node) of the tree starts with its name (<name>) and ends with (</name>). 

	- You can traverse the tree by starting at the root, <html>, and then moving through the nodes. 

	-  Headless browsers let you run a browser without actually opening the visual interface


## Python

Most Important Tools: 

	- Beautiful Soup: https://www.crummy.com/software/BeautifulSoup/
	- Selenium: https://selenium-python.readthedocs.io
	- Regular Expressions: regexr.com

Tutorials: 
	- https://www.pythonforbeginners.com/beautifulsoup/
	- https://www.crummy.com/software/BeautifulSoup/bs4/doc/
	- https://classes.cs.uchicago.edu/archive/2018/winter/30122-1/labs/lab1/index.html
	- https://classes.cs.uchicago.edu/archive/2018/winter/30122-1/labs/lab2/index.html


## R

Most Important Tools:
	
	- rvest: https://www.rdocumentation.org/packages/rvest/versions/0.3.2
	- Selenium/headless browser: https://www.r-bloggers.com/scraping-with-selenium/

Tutorials: 
	- https://www.r-bloggers.com/web-scraping-in-r/
	- https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/

## Other Headless Browsers

https://github.com/dhamaniasad/HeadlessBrowsers
