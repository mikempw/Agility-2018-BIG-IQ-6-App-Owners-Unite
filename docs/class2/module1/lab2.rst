Lab 1.2: Define your Cloud Environment
--------------------------------------

The next step is to define your cloud environment so that BIG-IQ will be able
to communicate with it and deploy F5 virtual edition. For this lab we will
leverage a VMWare infrastructure

Cloud Provider Setup
********************

In your BIG-IQ interface, go to *Applications* > *Environments* > *Cloud Providers*

.. image:: ../pictures/module1/img_module1_lab2_1.png
  :align: center
  :scale: 50%

|

Click on the *Create* button:

* Name: VMWareCloudProvider
* Provider Type: select *VMWARE*
* vCenter Hostname: 10.1.1.90


.. image:: ../pictures/module1/img_module1_lab2_2.png
  :align: center
  :scale: 50%

|

Click *Save & Close*. Now that your Cloud provider is setup, we can define your
``Cloud Environment``. Go to *Applications* > *Environments* > *Cloud Environments*
and click on the *Create* button

General Properties:

* Name: SSGClass2VMWareEnvironment
* Device Template: Select your previously created device template *SSGSetupClass2*
* Cloud Provider: Select your previously created Cloud provider *VMWareCloudProvider*

.. warning:: Careful everything is **case sensitive** here

VMWare Properties:

* DeployTo: Select *ESXi Hostname* and type: 10.1.1.9
* Datacenter: UDF
* Folder: Purple
* User: administrator@vsphere.local
* Password: Purpl3$lab
* VM Image: BIGIP-13.1.0.5-0.0.5.ALL_1SLOT_ASM_template
* Network Interface Mappings

  ========================== ===================
      Network Interface            Network
  ========================== ===================
          nic0                    VM Network
          nic1                      external
          nic2                      internal
  ========================== ===================


.. image:: ../pictures/module1/img_module1_lab2_3.png
    :align: center
    :scale: 50%

|

Click *Save & Close*

.. note:: with the Liberty release, we have a 1:1 mapping between the cloud
  provider and cloud environment. So a cloud provider can be used with only one
  cloud environment. This restriction will be removed with 6.0.1

We have setup all the different element defining our ``Service Scaling Group``
and can trigger its deployment now
