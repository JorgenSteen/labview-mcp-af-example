<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="26008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">26.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
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
		<Item Name="actors" Type="Folder"/>
		<Item Name="common" Type="Folder">
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
		</Item>
		<Item Name="receiver" Type="Folder"/>
		<Item Name="tests" Type="Folder">
			<Item Name="ZM-TST-tests.lvlib" Type="Library" URL="../tests/ZM-TST-tests.lvlib"/>
		</Item>
		<Item Name="ZM-CP-UDP-receiver.lvclass" Type="LVClass" URL="../protocol/ZM-CP-UDP-udp_transport/ZM-CP-UDP-receiver/ZM-CP-UDP-receiver.lvclass"/>
		<Item Name="ZM-CP-UDP-sender.lvclass" Type="LVClass" URL="../protocol/ZM-CP-UDP-udp_transport/ZM-CP-UDP-sender/ZM-CP-UDP-sender.lvclass"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
