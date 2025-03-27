<template>
  <div class="product-list">
    <div class="header">
      <h2>商品管理</h2>
      <el-button type="primary" @click="showAddDialog">添加商品</el-button>
    </div>

    <el-table :data="products" style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="商品名称" />
      <el-table-column prop="price" label="价格" width="120">
        <template #default="scope">
          ¥{{ scope.row.price }}
        </template>
      </el-table-column>
      <el-table-column prop="stock" label="库存" width="120" />
      <el-table-column prop="categoryName" label="分类" width="120" />
      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加/编辑商品对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="500px"
    >
      <el-form :model="productForm" :rules="rules" ref="productFormRef" label-width="100px">
        <el-form-item label="商品名称" prop="name">
          <el-input v-model="productForm.name" />
        </el-form-item>
        <el-form-item label="商品描述" prop="description">
          <el-input type="textarea" v-model="productForm.description" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="productForm.price" :precision="2" :step="0.1" :min="0" />
        </el-form-item>
        <el-form-item label="库存" prop="stock">
          <el-input-number v-model="productForm.stock" :min="0" />
        </el-form-item>
        <el-form-item label="分类" prop="categoryId">
          <el-select v-model="productForm.categoryId" placeholder="请选择分类">
            <el-option
              v-for="category in categories"
              :key="category.id"
              :label="category.name"
              :value="category.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="图片" prop="imageUrl">
          <el-input v-model="productForm.imageUrl" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

export default {
  name: 'ProductList',
  setup() {
    const products = ref([])
    const categories = ref([])
    const dialogVisible = ref(false)
    const dialogTitle = ref('添加商品')
    const productFormRef = ref(null)
    const productForm = ref({
      name: '',
      description: '',
      price: 0,
      stock: 0,
      categoryId: null,
      imageUrl: ''
    })
    const isEdit = ref(false)
    const currentId = ref(null)
    const loading = ref(false)
    const currentPage = ref(1)
    const pageSize = ref(10)
    const searchKeyword = ref('')
    const selectedCategory = ref(null)
    const total = ref(0)

    const rules = {
      name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
      price: [{ required: true, message: '请输入商品价格', trigger: 'blur' }],
      stock: [{ required: true, message: '请输入商品库存', trigger: 'blur' }],
      categoryId: [{ required: true, message: '请选择商品分类', trigger: 'change' }]
    }

    const fetchProducts = async () => {
      loading.value = true
      try {
        const response = await axios.get('/api/products', {
          params: {
            page: currentPage.value,
            size: pageSize.value,
            keyword: searchKeyword.value,
            categoryId: selectedCategory.value
          }
        })
        
        if (response.data.code === 200) {
          products.value = response.data.data.content
          total.value = response.data.data.totalElements
        } else {
          ElMessage.error(response.data.message || '获取商品列表失败')
        }
      } catch (error) {
        console.error('获取商品列表失败:', error)
        ElMessage.error('获取商品列表失败')
      } finally {
        loading.value = false
      }
    }

    const fetchCategories = async () => {
      try {
        const response = await axios.get('/api/products/categories')
        categories.value = response.data.data
      } catch (error) {
        ElMessage.error('获取分类列表失败')
      }
    }

    const showAddDialog = () => {
      dialogTitle.value = '添加商品'
      isEdit.value = false
      productForm.value = {
        name: '',
        description: '',
        price: 0,
        stock: 0,
        categoryId: null,
        imageUrl: ''
      }
      dialogVisible.value = true
    }

    const handleEdit = (row) => {
      dialogTitle.value = '编辑商品'
      isEdit.value = true
      currentId.value = row.id
      productForm.value = { ...row }
      dialogVisible.value = true
    }

    const handleDelete = async (id) => {
      try {
        await ElMessageBox.confirm('确定要删除这个商品吗？', '提示', {
          type: 'warning'
        })
        const response = await axios.delete(`/api/products/${id}`)
        if (response.data.code === 200) {
          ElMessage.success('删除成功')
          fetchProducts()
        } else {
          ElMessage.error(response.data.message || '删除失败')
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除商品失败:', error)
          ElMessage.error('删除商品失败')
        }
      }
    }

    const handleSubmit = async () => {
      if (!productFormRef.value) return
      
      await productFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            if (isEdit.value) {
              await axios.put(`/api/products/${currentId.value}`, productForm.value)
            } else {
              await axios.post('/api/products', productForm.value)
            }
            ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
            dialogVisible.value = false
            fetchProducts()
          } catch (error) {
            ElMessage.error(isEdit.value ? '更新失败' : '添加失败')
          }
        }
      })
    }

    onMounted(() => {
      fetchProducts()
      fetchCategories()
    })

    return {
      products,
      categories,
      dialogVisible,
      dialogTitle,
      productForm,
      productFormRef,
      rules,
      showAddDialog,
      handleEdit,
      handleDelete,
      handleSubmit
    }
  }
}
</script>

<style scoped>
.product-list {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style> 