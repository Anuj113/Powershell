param (
   [Parameter(Mandatory=$true)][int]$time
 )

$countdown = $time

while ($countdown -gt 0){
	echo "[Countdown] $countdown second left before proceeding with next action..."
	ping 127.0.0.1 -n 2 >$null
	$countdown = $countdown - 1
}