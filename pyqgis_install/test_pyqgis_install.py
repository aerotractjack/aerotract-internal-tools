from qgis.core import QgsApplication

QgsApplication.setPrefixPath("/usr/bin/qgis", True)

qgs = QgsApplication([], False)

qgs.initQgis()

print("Nice dude!!")

qgs.exitQgis()
