<template>
  <div class="category-list">
    <div class="header">
      <h2>分类管理</h2>
      <el-button type="primary" @click="showAddDialog">添加分类</el-button>
    </div>

    <el-table :data="categories" style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="分类名称" />
      <el-table-column prop="description" label="描述" />
      <el-table-column prop="parentName" label="父分类" width="120" />
      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加/编辑分类对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="500px"
    >
      <el-form :model="categoryForm" :rules="rules" ref="categoryFormRef" label-width="100px">
        <el-form-item label="分类名称" prop="name">
          <el-input v-model="categoryForm.name" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input type="textarea" v-model="categoryForm.description" />
        </el-form-item>
        <el-form-item label="父分类" prop="parentId">
          <el-select v-model="categoryForm.parentId" placeholder="请选择父分类">
            <el-option label="无" :value="null" />
            <el-option
              v-for="category in categories"
              :key="category.id"
              :label="category.name"
              :value="category.id"
            />
          </el-select>
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
  name: 'CategoryList',
  setup() {
    const categories = ref([])
    const dialogVisible = ref(false)
    const dialogTitle = ref('添加分类')
    const categoryFormRef = ref(null)
    const categoryForm = ref({
      name: '',
      description: '',
      parentId: null
    })
    const isEdit = ref(false)
    const currentId = ref(null)
    const loading = ref(false)

    const rules = {
      name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
    }

    const fetchCategories = async () => {
      loading.value = true
      try {
        const response = await axios.get('/api/products/categories')
        if (response.data.code === 200) {
          categories.value = response.data.data
        } else {
          ElMessage.error(response.data.message || '获取分类列表失败')
        }
      } catch (error) {
        console.error('获取分类列表失败:', error)
        ElMessage.error('获取分类列表失败')
      } finally {
        loading.value = false
      }
    }

    const showAddDialog = () => {
      dialogTitle.value = '添加分类'
      isEdit.value = false
      categoryForm.value = {
        name: '',
        description: '',
        parentId: null
      }
      dialogVisible.value = true
    }

    const handleEdit = (row) => {
      dialogTitle.value = '编辑分类'
      isEdit.value = true
      currentId.value = row.id
      categoryForm.value = { ...row }
      dialogVisible.value = true
    }

    const handleDelete = async (id) => {
      try {
        await ElMessageBox.confirm('确定要删除这个分类吗？', '提示', {
          type: 'warning'
        })
        const response = await axios.delete(`/api/products/categories/${id}`)
        if (response.data.code === 200) {
          ElMessage.success('删除成功')
          fetchCategories()
        } else {
          ElMessage.error(response.data.message || '删除失败')
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除分类失败:', error)
          ElMessage.error('删除分类失败')
        }
      }
    }

    const handleSubmit = async () => {
      if (!categoryFormRef.value) return
      
      await categoryFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            const url = isEdit.value ? `/api/products/categories/${currentId.value}` : '/api/products/categories'
            const method = isEdit.value ? 'put' : 'post'
            const response = await axios[method](url, categoryForm.value)
            
            if (response.data.code === 200) {
              ElMessage.success(isEdit.value ? '更新成功' : '添加成功')
              dialogVisible.value = false
              fetchCategories()
            } else {
              ElMessage.error(response.data.message || (isEdit.value ? '更新失败' : '添加失败'))
            }
          } catch (error) {
            console.error(isEdit.value ? '更新分类失败:' : '添加分类失败:', error)
            ElMessage.error(isEdit.value ? '更新失败' : '添加失败')
          }
        }
      })
    }

    onMounted(() => {
      fetchCategories()
    })

    return {
      categories,
      dialogVisible,
      dialogTitle,
      categoryForm,
      categoryFormRef,
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
.category-list {
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