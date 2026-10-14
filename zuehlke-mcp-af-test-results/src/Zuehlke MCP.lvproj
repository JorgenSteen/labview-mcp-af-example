<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="20008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">20.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.Project.Description" Type="Str"></Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="actors" Type="Folder">
			<Item Name="ZM-CM-communication_manager.lvlib" Type="Library" URL="../actors/ZM-CM-communication_manager/ZM-CM-communication_manager.lvlib"/>
			<Item Name="ZM-HWM-hardware_manager.lvlib" Type="Library" URL="../actors/ZM-HWM-hardware_manager/ZM-HWM-hardware_manager.lvlib"/>
			<Item Name="ZM-ROOT-root.lvlib" Type="Library" URL="../actors/ZM-ROOT-root/ZM-ROOT-root.lvlib"/>
		</Item>
		<Item Name="common" Type="Folder">
			<Item Name="ZM-CI-common_interfaces.lvlib" Type="Library" URL="../common/ZM-CI-common_interfaces/ZM-CI-common_interfaces.lvlib"/>
			<Item Name="ZM-CU-common_utilities.lvlib" Type="Library" URL="../common/ZM-CU-common_utilities/ZM-CU-common_utilities.lvlib"/>
			<Item Name="ZM-PC-packages.lvlib" Type="Library" URL="../common/ZM-PC-packages/ZM-PC-packages.lvlib"/>
		</Item>
		<Item Name="hardware" Type="Folder">
			<Item Name="ZM-HW-hardware.lvlib" Type="Library" URL="../hardware/ZM-HW-hardware/ZM-HW-hardware.lvlib"/>
			<Item Name="ZM-HW-SIM-simulated_hardware.lvlib" Type="Library" URL="../hardware/ZM-HW-SIM-simulated_hardware/ZM-HW-SIM-simulated_hardware.lvlib"/>
		</Item>
		<Item Name="protocol" Type="Folder">
			<Item Name="ZM-CP-communication_protocol.lvlib" Type="Library" URL="../protocol/ZM-CP-communication_protocol/ZM-CP-communication_protocol.lvlib"/>
			<Item Name="ZM-CP-FL-file_logger.lvlib" Type="Library" URL="../protocol/ZM-CP-FL-file_logger/ZM-CP-FL-file_logger.lvlib"/>
			<Item Name="ZM-CP-MX-multi_protocol.lvlib" Type="Library" URL="../protocol/ZM-CP-MX-multi_protocol/ZM-CP-MX-multi_protocol.lvlib"/>
			<Item Name="ZM-CP-UDP-udp_transport.lvlib" Type="Library" URL="../protocol/ZM-CP-UDP-udp_transport/ZM-CP-UDP-udp_transport.lvlib"/>
		</Item>
		<Item Name="receiver" Type="Folder">
			<Item Name="ZM-receiver.vi" Type="VI" URL="../receiver/ZM-receiver.vi"/>
		</Item>
		<Item Name="tests" Type="Folder">
			<Item Name="ZM-launcher_test.vi" Type="VI" URL="../ZM-launcher_test.vi"/>
			<Item Name="ZM-TST-tests.lvlib" Type="Library" URL="../tests/ZM-TST-tests.lvlib"/>
		</Item>
		<Item Name="ZM-launcher.vi" Type="VI" URL="../ZM-launcher.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
