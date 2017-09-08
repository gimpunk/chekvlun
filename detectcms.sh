jsonresult(){
	wordx=$1
	cat domain | python -c "import json,sys;obj=json.load(sys.stdin);print obj['$wordx']"
}
domainresult(){

	php -r '$a = file_get_contents("domain"); $b = json_decode($a); foreach($b->domainArray as $c=>$d){$fp = fopen("domainarray.txt", "a+"); fwrite($fp, $d[0]."\n"); fclose($fp);}'
}
detectcms(){
curl -s --max-time 10 --connect-timeout 10 $1 > checkcms
cat checkcms | grep 'The document has moved' > /dev/null;checkhttps=$?
if [ $checkhttps -eq 0 ]
then
curl -s --max-time 10 --connect-timeout 10 "https://$1" > checkcms
fi
for cms in `cat cms.txt`
do
	cat checkcms | grep "$cms" > /dev/null;cmsx=$?
	if [ $cmsx -eq 0 ]
	then
	caseresult $cms
	fi
done
}
caseresult(){
case $1 in
	media/css)
	echo "Magento"
	break
	;;
	wp-content/plugins)
	echo "Wordpress"
	break
	;;
	skin/frontend)
	echo "Magento"
	break
	;;
	sites/all)
	echo "Drupal"
	break
	;;
	media/jui/js/jquery.min.js)
	echo "Joomla"
	break
	;;
	Joomla)
	echo "Joomla"
	break
	;;
	component/content/)
	echo "Joomla"
	break
	;;
	vbulletin-core.js)
	echo "Vbulletin"
	break
	;;
esac
}