view = application.View.RecordingView.Panel("Readings");
stats = view.Panel(0).Statistics;
ave = stats.StatisticValue(0, 2, 0);
area = stats.StatisticValue(0, 8, 0);
units = stats.StatisticUnits(2);

uc = new ActiveXObject("FSA4.UnitConverter");
average = uc.Convert(ave, units, "g/cm");

message = "Average = " + ave.toFixed(2) + " " + units 
	+ "\r\nArea = " + area.toFixed(2) + " sq.cm.\r\nWeight = " 
	+ (average * area / 1000).toFixed(2) + " kg";
application.ShowMessage(message, 0);