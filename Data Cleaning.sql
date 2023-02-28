Select *
from NashVilleHousing

-- Standardize Data Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
from NashVilleHousing

update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address Data

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
IsNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

Update a
set PropertyAddress = IsNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking ot Address into Individual Columns (Address, City, State)

select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
from NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1)

Alter table NashvilleHousing
Add PropertySplitScity Nvarchar(255);

update NashvilleHousing
set PropertySplitScity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select * 
from NashvilleHousing

Select OwnerAddress
from NashvilleHousing

Select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing 

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
from NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
,  Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		End
from NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		End

-- Remove Duplicates

With RownumCTE as (
Select *,
ROW_NUMBER() Over (
Partition by ParcelID, PropertyAddress, SalePrice, SaleDate,  LegalReference
Order by UniqueID) row_num
from NashvilleHousing
--order by ParcelID
)
Select * 
from RownumCTE
Where row_num > 1
order by PropertyAddress


-- Delete Unused Columns

select * 
from NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table NashvilleHousing
Drop Column SaleDate