import urllib
import urllib.request, urllib.error, urllib.parse
import json
import requests
import ssl
import sys
from optparse import OptionParser
#from pprint import pprint
import codecs
codecs.register(lambda name: codecs.lookup('utf-8') if name == 'cp65001' else None)
"""was using this to see what I had currently, could be useful later"""

ssl._create_default_https_context = ssl._create_unverified_context

parser = OptionParser()


parser.add_option("-l", "--list",
                  dest="list", action='store_true', default=False,
                  help="list available releases")

parser.add_option("--linux",
                  dest="Linux",action='store_true', default=False,
                  help="find the linux release data")
                  
parser.add_option("--osx",
                  dest="osx",action='store_true', default=False,
                  help="find the osx release data")
parser.add_option("--windows",
                  dest="win64",action='store_true', default=False,
                  help="find the windows release data")
                  
parser.add_option("--src",
                  dest="src",action='store_true', default=False,
                  help="find the src release data")
parser.add_option("--noexamples",
                  dest="noexamples",action='store_true', default=False,
                  help="Show everything except example data")
parser.add_option('-a',"--all",
                  dest="all",action='store_true', default=False,
                  help="find all release data (default)")
parser.add_option("--software",dest = "software",
                  default="cleaver",
                  help="software to report:  cleaver (default), cleaver2, shapeworks, shapeworksstudio, seg3d, scirun, map3d, uncertainsci, fluorender, imagevis3d")
                  
(options,args) = parser.parse_args()


                        
os_version = ['Linux', 'osx', 'src', 'win32']
version_num = ['v2.0','v2.1b','v2.1']

os_tags = []

if options.osx or options.noexamples:
    os_tags += ['osx', 'mac', 'dmg', 'pkg', '.app', 'Darwin']
    all = False
if options.Linux or options.noexamples:
    os_tags += ['linux' ]
    all = False
if options.win64 or options.noexamples:
    os_tags += ['windows', 'win64','win32', 'exe']
    all = False
if options.src or options.noexamples:
    os_tags += ['src', 'source']
    all = False
if options.noexamples:
    os_tags += ['bin', 'binaries']
    all = False

repo_lookup = {"shapeworks" : "https://api.github.com/repos/SCIInstitute/shapeworks/releases",
                "shapeworksstudio" : "https://api.github.com/repos/SCIInstitute/shapeworksstudio/releases",
                "cleaver2" : "https://api.github.com/repos/SCIInstitute/cleaver2/releases",
                "cleaver" : "https://api.github.com/repos/SCIInstitute/cleaver/releases",
                "itkcleaver" : "https://api.github.com/repos/SCIInstitute/ITKCleaver/releases",
                "seg3d"  : "https://api.github.com/repos/SCIInstitute/Seg3D/releases",
                "scirun" : "https://api.github.com/repos/SCIInstitute/SCIRun/releases",
                "imagevis3d" : "https://api.github.com/repos/SCIInstitute/ImageVis3D/releases",
                "fluorender" : "https://api.github.com/repos/SCIInstitute/FluoRender/releases",
                "map3d" : "https://api.github.com/repos/SCIInstitute/map3d/releases",
                "uncertainsci" : "https://api.github.com/repos/SCIInstitute/UncertainSCI/releases"
}


with urllib.request.urlopen(repo_lookup[options.software]) as response:
   html = response.read()
#data = urllib2.urlopen("https://api.github.com/repos/SCIInstitute/PFEIFERen /releases")
#html = data.read()
listofreleases = json.loads(html)

print(os_tags)

if not all and not options.all:
    all_tot_count = 0
    for number in listofreleases:
        releasename = number.get("name")
        print("\n" + releasename)
        listofassets = number.get("assets")
        print(number.get("created_at") + "\n")
        tot_count=0
        for info in listofassets:
            name = info.get("name")
            if any(tag in name.lower() for tag in os_tags ):
                print(name)
                count = info.get("download_count")
                print("Download Count = " + str(count))
                tot_count +=count
        print("Total Release Downloads : " +str(tot_count))
        all_tot_count+=tot_count
    print("Downloads from all releases (listed) : " + str(all_tot_count))
                

#lists releases available
if options.list == True:
    all = False
    print("\n" + "RELEASES LIST")
    for number in listofreleases:
        releasename = number.get("name")
        print("\n" + releasename)
                            


#the else case, prints all releases
if options.all or all:
    print("\n \n" + "ALL RELEASES")
    for number in listofreleases:
        releasename = number.get("name")
        print("\n" + releasename)
        listofassets = number.get("assets")
        print(number.get("created_at") + "\n")
        for info in listofassets:
            print(info.get("name"))
            count = info.get("download_count")
            print("Download Count = " + str(count))
 

                            
